#!/bin/bash
# Geospatial Data Processing Workflow
# Copyright (C) 2021, Wouter Knoben
# Copyright (C) 2022-2023, University of Saskatchewan
# Copyright (C) 2023, University of Calgary
#
# This file is part of Geospatial Data Processing Workflow
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# =========================
# Credits and contributions
# =========================
# 1. Parts of the code are taken from https://www.shellscript.sh/tips/getopt/index.html
# 2. General ideas of GeoTIFF subsetting are taken from https://github.com/CH-Earth/CWARHM
#    developed mainly by Wouter Knoben (hence the header copyright credit). See the preprint
#    at: https://www.essoar.org/doi/10.1002/essoar.10509195.1


# ================
# General comments
# ================
# * All variables are camelCased for distinguishing from function names;
# * function names are all in lower_case with words seperated by underscore for legibility;
# * shell style is based on Google Open Source Projects'
#   Style Guide: https://google.github.io/styleguide/shellguide.html


# ===============
# Usage Functions
# ===============
short_usage() {
  echo "usage: $(basename $0) -cio DIR -v var1[,var2[...]] [-r INT] [-se DATE] [-ln REAL,REAL] [-f PATH] [-F STR] [-t BOOL] [-a stat1[,stat2,[...]] [-u BOOL] [-q q1[,q2[...]]]] [-p STR] "
}


# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n modis -o i:o:v:r:s:e:l:n:f:F:t:a:u:q:p:c:L: --long dataset-dir:,output-dir:,variable:,crs:,start-date:,end-date:,lat-lims:,lon-lims:,shape-file:,fid:,print-geotiff:,stat:,include-na:,quantile:,prefix:,cache:,lib-path: -- "$@")
validArguments=$?
if [ "$validArguments" != "0" ]; then
  short_usage;
  exit 1;
fi

# check if no options were passed
if [ $# -eq 0 ]; then
  echo "$(basename $0): ERROR! arguments missing";
  exit 1;
fi

# check long and short options passed
eval set -- "$parsedArguments"
while :
do
  case "$1" in
    -i | --dataset-dir)   geotiffDir="$2"      ; shift 2 ;; # required
    -o | --output-dir)    outputDir="$2"       ; shift 2 ;; # required
    -v | --variable)      variables="$2"       ; shift 2 ;; # required
    -r | --crs)           crs="$2"             ; shift 2 ;; # required 
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # required
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # required
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # required - could be redundant
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # required - could be redundant
    -f | --shape-file)    shapefile="$2"       ; shift 2 ;; # required - could be redundant
    -F | --fid)           fid="$2"             ; shift 2 ;; # optional
    -t | --print-geotiff) printGeotiff="$2"    ; shift 2 ;; # required
    -a | --stat)          stats="$2"           ; shift 2 ;; # optional
    -u | --include-na)    includeNA="$2"       ; shift 2 ;; # required
    -q | --quantile)      quantiles="$2"       ; shift 2 ;; # optional
    -p | --prefix)        prefix="$2"          ; shift 2 ;; # optional
    -c | --cache)         cache="$2"           ; shift 2 ;; # required
    -L | --lib-path)      renvCache="$2"       ; shift 2 ;; # required

    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;

    # in case of invalid option
    *)
      echo "$(basename $0): ERROR! invalid option '$1'";
      short_usage; exit 1 ;;
  esac
done

# check if $ensemble is provided
if [[ -z "$startDate" ]] || [[ -z "$endDate" ]]; then
  echo "$(basename $0): Warning! time extents missing, considering full time range";
  startDate="2001"
  endDate="2020"
fi

# check the prefix if not set
if [[ -z $prefix ]]; then
  prefix="modis_"
fi

# parse comma-delimited variables
IFS=',' read -ra variables <<< "${variables}"


# =====================
# Necessary Assumptions
# =====================
# TZ to be set to UTC to avoid invalid dates due to Daylight Saving
alias date='TZ=UTC date'
# expand aliases for the one stated above
shopt -s expand_aliases

# necessary hard-coded paths
exactextractrCache="${renvCache}/exact-extract-env" # exactextractr renv cache path
renvPackagePath="${renvCache}/renv_0.16.0.tar.gz" # renv_0.16.0 source path


# ==========================
# Necessary Global Variables
# ==========================
# None


# ===================
# Necessary Functions
# ===================
# Modules below available on Compute Canada (CC) Graham Cluster Server
load_core_modules () {
    module -q purge
    module -q load gcc/9.3.0
    module -q load r/4.1.2
    module -q load gdal/3.0.4
    module -q load udunits/2.2.28
    module -q load geos/3.10.2
    module -q load proj/9.0.0
}
load_core_modules


# =================
# Useful One-liners
# =================
# sorting a comma-delimited string of real numbers
sort_comma_delimited () { IFS=',' read -ra arr <<< "$*"; echo ${arr[*]} | tr " " "\n" | sort -n | tr "\n" " "; }

# log date format
logDate () { echo "($(date +"%Y-%m-%d %H:%M:%S")) "; }


#######################################
# subset GeoTIFFs
#
# Globals:
#   latLims: comma-delimited latitude
#            limits
#   lonLims: comma-delimited longitude
#            limits
#
# Arguments:
#   sourceVrt: source vrt file (or
# 	       tif!)
#   destPath: destionation path (inclu-
#	      ding file name)
#
# Outputs:
#   one mosaiced (merged) GeoTIFF under
#   the $destDir
#######################################
subset_geotiff () {
  # local variables
  local latMin
  local latMax
  local lonMin
  local lonMax
  local sortedLats
  local sortedLons
  # reading arguments
  local sourceVrt="$1"
  local destPath="$2"

  # extracting minimum and maximum of latitude and longitude respectively
  ## latitude
  sortedLats=($(sort_comma_delimited "$latLims"))
  latMin="${sortedLats[0]}"
  latMax="${sortedLats[1]}"
  ## longitude
  sortedLons=($(sort_comma_delimited "$lonLims"))
  lonMin="${sortedLons[0]}"
  lonMax="${sortedLons[1]}"

  # subset based on lat/lon - flush to disk at 500MB
  GDAL_CACHEMAX=500
  gdal_translate --config GDAL_CACHEMAX 500 \
  		 -co COMPRESS="DEFLATE" \
  		 -co BIGTIFF="YES" \
       -projwin $lonMin $latMax $lonMax $latMin "${sourceVrt}" "${destPath}" \
		 > /dev/null;
}


# ===============
# Data Processing
# ===============
# display info
echo "$(logDate)$(basename $0): processing MODIS HDF(s)..."

# make the cache directory
echo "$(logDate)$(basename $0): creating cache directory under $cache"
mkdir -p "$cache"

# make the output directory
echo "$(logDate)$(basename $0): creating output directory under $outputDir"
mkdir -p "$outputDir" # making the output directory

# extract the start and end years
startYear="$(date --date="$startDate" +"%Y")"
endYear="$(date --date="$endDate" +"%Y")"
yearsRange=($(seq $startYear $endYear))

# if shapefile is provided extract the extents from it
if [[ -n $shapefile ]]; then
  # extract the shapefile extent
  IFS=' ' read -ra shapefileExtents <<< "$(ogrinfo -so -al "$shapefile" | sed 's/[),(]//g' | grep Extent)"
  # transform the extents in case they are not in EPSG:4326
  IFS=':' read -ra sourceProj4 <<< "$(gdalsrsinfo $shapefile | grep -e "PROJ.4")" # source Proj4 value
  if [[ -n $sourceProj4 ]]; then
    :
  else
    echo "$(logDate)$(basename $0): WARNING! Assuming WSG84 CRS for the input ESRI shapefile"
    sourceProj4=("PROJ.4" " +proj=longlat +datum=WGS84 +no_defs") # made an array for compatibility with the following statements
  fi
  
  # transform limits and assing to variables
  IFS=' ' read -ra leftBottomLims <<< $(echo "${shapefileExtents[@]:1:2}" | gdaltransform -s_srs "${sourceProj4[1]}" -t_srs EPSG:4326 -output_xy)
  IFS=' ' read -ra rightTopLims <<< $(echo "${shapefileExtents[@]:4:5}" | gdaltransform -s_srs "${sourceProj4[1]}" -t_srs EPSG:4326 -output_xy)
  # define $latLims and $lonLims from $shapefileExtents
  lonLims="${leftBottomLims[0]},${rightTopLims[0]}"
  latLims="${leftBottomLims[1]},${rightTopLims[1]}"
fi

# build .vrt file out of annual MODIS HDFs for each of the $variables
echo "$(logDate)$(basename $0): building virtual format (.vrt) of MODIS HDFs under $cache"
for var in "${variables[@]}"; do
  for yr in "${yearsRange[@]}"; do
    # format year to conform to MODIS nomenclature
    yrFormatted="${yr}.01.01"
    
    # create temporary directories for each variable
    mkdir -p "${cache}/${var}"
    
    # make .vrt out of each variable's HDFs 
    # ATTENTION: the second argument is not contained with quotation marks
    gdalbuildvrt "${cache}/${var}/${yr}.vrt" ${geotiffDir}/${var}/${yrFormatted}/*.hdf -resolution highest -sd 1 > /dev/null
    
    # reproject .vrt to the standard EPSG:4326 projection
    gdalwarp -of VRT -t_srs "EPSG:$crs" "${cache}/${var}/${yr}.vrt" "${cache}/${var}/${yr}_${crs}.vrt" > /dev/null
  done
done

# subset and produce stats if needed
echo "$(logDate)$(basename $0): subsetting HDFs in GeoTIFF format under $outputDir"
# for each given year
for var in "${variables[@]}"; do
  mkdir -p ${outputDir}/${var}  
  # for each year 
  for yr in "${yearsRange[@]}"; do
    # subset based on lat and lon values
    if [[ "$printGeotiff" == "true" ]]; then
      subset_geotiff "${cache}/${var}/${yr}_${crs}.vrt" "${outputDir}/${var}/${prefix}${yr}.tif"
    elif [[ "$printGeotiff" == "false" ]]; then
      subset_geotiff "${cache}/${var}/${yr}_${crs}.vrt" "${cache}/${var}/${prefix}${yr}.tif"
    fi
  done
done

## make R renv project directory
if [[ -n "$shapefile" ]] && [[ -n $stats ]]; then
  echo "$(logDate)$(basename $0): Extracting stats under $outputDir"
  mkdir -p "$cache/r-virtual-env/"
  ## make R renv in $cache
  virtualEnvPath="$cache/r-virtual-env/"
  cp "$(dirname $0)/../assets/renv.lock" "$virtualEnvPath"
  ## load necessary modules - excessive, mainly for clarification
  load_core_modules

  for var in "${variables[@]}"; do
    # extract given stats for each variable

    for yr in "${yearsRange[@]}"; do
      # raster file path based on $printGeotiff value
      if [[ "$printGeotiff" == "true" ]]; then
        rasterPath="${outputDir}/${var}/${prefix}${yr}.tif"
      elif [[ "$printGeotiff" == "false" ]]; then
        rasterPath="${cache}/${var}/${prefix}${yr}.tif"
      fi

      ## make the temporary directory for installing r packages
      tempInstallPath="$cache/r-packages"
      mkdir -p "$tempInstallPath"
      export R_LIBS_USER="$tempInstallPath"

      ## build renv and create stats
      Rscript "$(dirname $0)/../assets/stats.R" \
      	      "$tempInstallPath" \
  	      "$exactextractrCache" \
  	      "$renvPackagePath" \
	      "$virtualEnvPath" \
	      "$virtualEnvPath" \
	      "${virtualEnvPath}/renv.lock" \
	      "$rasterPath" \
	      "$shapefile" \
	      "$outputDir/${var}/${prefix}stats_${var}_${yr}.csv" \
	      "$stats" \
	      "$includeNA" \
	      "$quantiles" \
	      "$fid" >> "${outputDir}/${var}/${prefix}stats_${var}_${yr}.log" 2>&1;
    done
  done
fi

# produce stats if required
mkdir "$HOME/empty_dir" 
echo "$(logDate)$(basename $0): deleting temporary files from $cache"
rsync --quiet -aP --delete "$HOME/empty_dir/" "$cache"
rm -r "$cache"
echo "$(logDate)$(basename $0): temporary files from $cache are removed"
echo "$(logDate)$(basename $0): results are produced under $outputDir"

