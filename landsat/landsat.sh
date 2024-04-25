#!/bin/bash
# Geospatial Data Processing Workflow
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
# * 7z is needed as a dependency program


# ===============
# Usage Functions
# ===============
short_usage() {
  echo "usage: $(basename $0) -cio DIR -v var1[,var2[...]] [-r INT] [-se DATE] [-ln REAL,REAL] [-f PATH] [-F STR] [-t BOOL] [-a stat1[,stat2,[...]] [-u BOOL] [-q q1[,q2[...]]]] [-p STR] "
}


# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n landsat -o i:o:v:r:s:e:l:n:f:F:t:a:u:q:p:c:L: --long dataset-dir:,output-dir:,variable:,crs:,start-date:,end-date:,lat-lims:,lon-lims:,shape-file:,fid:,print-geotiff:,stat:,include-na:,quantile:,prefix:,cache:,lib-path: -- "$@")
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
    -r | --crs)		  crs="$2"	       ; shift 2 ;; # required 
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # optional 
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # optional
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # required - could be redundant
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # required - could be redundant
    -f | --shape-file)    shapefile="$2"       ; shift 2 ;; # required - could be redundant
    -F | --fid)           fid="$2"             ; shift 2 ;; # optional
    -t | --print-geotiff) printGeotiff="$2"    ; shift 2 ;; # required
    -a | --stat)	  stats="$2"	       ; shift 2 ;; # optional
    -u | --include-na)	  includeNA="$2"       ; shift 2 ;; # required
    -q | --quantile)	  quantiles="$2"       ; shift 2 ;; # optional
    -p | --prefix)	  prefix="$2"          ; shift 2 ;; # optional
    -c | --cache)	  cache="$2"           ; shift 2 ;; # required
    -L | --lib-path)      renvCache="$2"       ; shift 2 ;; # required

    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;

    # in case of invalid option
    *)
      echo "$(basename $0): ERROR! invalid option '$1'";
      short_usage; exit 1 ;;
  esac
done


# check the prefix if not set
if [[ -z $prefix ]]; then
  prefix="landsat_"
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
# the structure of the landcover file names is as following:
#     * land_cover_%YYYYv2_30m_tif.zip, or
#     * land_cover_%YYYY_30m_tif.zip,
# and the structure of the landcover change file name is as following:
#     * land_change_2010v2_2015v2_30m_tif.zip
#
# for the first type of nomenclature, the --start-date and --end-date
# arguments are used to access either 2010 or the 2015 dataset; it is
# expected that the --variable argument to be equal to the following:
# 'land_cover'
#
# for the second type of nomenclature, the --variable argument will
# be equal to 'land_cover_change'

# valid years when landsat landcover data are available
validYears=(2005 2010 2015 2020) # update as new data becomes available

# constant prefix landcover's nomeclature
landcoverPrefix="land_cover_"

# constant name for landcoverchange's
landcoverchangeFile="land_change_2010v2_2015v2_30m_tif.zip"


# ===================
# Necessary Functions
# ===================
# Modules below available on Compute Canada (CC) Graham Cluster Server
load_core_modules () {
    module -q purge
    module -q load StdEnv/2020
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
#   sourceVrt: source vrt file
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
		 -projwin "$lonMin" "$latMax" "$lonMax" "$latMin" "${sourceVrt}" "${destPath}" \
		 > /dev/null;
}

#######################################
# Extract ESRI Shapefile extents 
#
# Globals:
#   lonLims: longitude limits in
#	     lat/lon system
#   latLims: latitude limits in
#	     lat/lon system
#
# Arguments:
#   shapefilePath: path to the ESRI
#		   Shapefile
#   destProj4: destination projection,
#	       (optional)
#
# Outputs:
#   one mosaiced (merged) GeoTIFF under
#   the $destDir
#######################################
extract_shapefile_extents () {
  # local variables
  local shapefileExtents # ogrinfo output containing ESIR Shapefile extents
  local sourceProj4 # projection in proj4 format
  local leftBottomLims # left bottom coordinates (min lon, min lat)
  local rightTopLims # top right coordinates (max lon, max lat)

  # reading arguments
  local shapefilePath=$1
  local destProj4=$2

  # extract PROJ.4 string for $shapefilePath
  sourceProj4=$(ogrinfo -al -so "$shapefilePath" | grep -e "PROJ.4" 2>/dev/null)

  # if $sourceProj4 is missing, assign EPSG:4326 as default value and warn
  if [[ -z "$sourceProj4" ]]; then
    sourceProj4="EPSG:4326"
    echo "$(logDate)$(basename $0): WARNING! Assuming EPSG:4326 for the" \
    		"input ESRI Shapefile to extract the extents"
  fi

  # if $destProj4 provided, reproject and extract extent in the new
  # projection
  if [[ -n $destProj4 && "$destProj4" != "$sourceProj4" ]]; then
    # temporary shapefile's path
    tempShapefile="${cache}/temp_reprojected.shp"

    # reproject ESRI shapefile to $destProj4
    ogr2ogr -f "ESRI Shapefile" "${tempShapefile}" "${shapefilePath}" -s_srs \
      "$sourceProj4" -t_srs "$destProj4" 2>"${outputDir}/misc.log"

    # assign the path of the projected file as the $shapefilePath
    shapefilePath="${tempShapefile}"
  fi

  # extract the shapefile extent
  IFS=' ' read -ra shapefileExtents <<< "$(ogrinfo -so -al "$shapefilePath" | sed 's/[),(]//g' | grep Extent)"
 
  # transform limits and assigning to relevant variables
  IFS=' ' read -ra lowerLeftLims <<< $(echo "${shapefileExtents[@]:1:2}")
  IFS=' ' read -ra upperRightLims <<< $(echo "${shapefileExtents[@]:4:5}")

  # define $latLims and $lonLims from $shapefileExtents
  lonLims="${lowerLeftLims[0]},${upperRightLims[0]}"
  latLims="${lowerLeftLims[1]},${upperRightLims[1]}"
}

#######################################
# Transform projection based on source
#     Proj4 string
#
# Globals:
#   None
#
# Arguments:
#   sourceProj4: string describing
#                source projection
#   coords: comma-separated coordinate
#	    values
#   coordsDelim: delimited in the 
#    		 $coords variable
#   transformDelim: delimtied in the
# 		    transformed values
#   destEPSG: EPSG value of the
#	      destination projection
#	      (default 'EPSG:4326')
#
# Outputs:
#   comma-delimited $coords in the
#   $destEPSG format
#######################################
transform_coords () {
  # local variables
  local sourceProj4="$1"
  local coords="$2"
  local coordsDelim="$3"
  local transformDelim="$4"
  local destEPSG="$5"
  # local variables assigned in the function
  local coordsBlankDel
  local coordsTrans

  # if $destEPSG not provided, use EPSG:4326 by default
  if [[ -z $destEPSG ]]; then
    destEPSG='EPSG:4326'
  fi

  # if $coordsDelim not provided, use comma ',' by default
  if [[ -z $coordsDelim ]]; then
    coordsDelim=','
  fi

  # substituting comma with a blank space
  coordsBlankDel=$(echo "$coords" | tr "${coordsDelim}" ' ')

  # transforming coords
  coordsTrans=$(echo "$coordsBlankDel" | gdaltransform -s_srs "${sourceProj4}" -t_srs "${destEPSG}" -output_xy)

  # subtitute blank space with $transformDelim value
  if [[ -n $transformDelim ]]; then
    coordsTrans=$(echo "$coordsTrans" | tr ' ' $transformDelim)
  fi
  
  # echo-ing $coordsTrans variable
  echo "${coordsTrans}"
}


# ===============
# Data Processing
# ===============
# display info
echo "$(logDate)$(basename $0): processing Landsat GeoTIFF(s)..."

# make the output directory
echo "$(logDate)$(basename $0): creating output directory under $outputDir"
mkdir -p "$cache" # making the cache directory
mkdir -p "$outputDir" # making the output directory

# list .zip file names to be 
## creating an empty global array to keep the file names
files=()

## checking the variable name and populate above array
for var in "${variables[@]}"; do

  # check $var name
  case "${var,,}" in

    # land-cover variable(s)
    "land-cover" | "land_cover" | "landcover" | "land cover")
      ### check if the $startDate and $endDate variables are set
      if [[ -z ${startDate} ]] || [[ -z ${endDate} ]]; then
        echo "$(logDate)$(basename $0): ERROR! Both"' `--start-date` and `--end-date` must be provided'
	exit 1;
      fi
      # extract the entered years and populate $files array
      for y in "${validYears[@]}"; do
        if [[ "$y" -ge "${startDate}" ]] && [[ "$y" -le "${endDate}" ]]; then
	  files+=("${landcoverPrefix}${y}")
	fi
      done
      ;;

    # land-cover-change variable
    "landcoverchange" | "land-cover-change" | "land_cover_change" | "land_cover-change" | "land-cover_change" | "land cover change" )
      ### check if the $startDate and $endDate variables are provided
      if [[ -n ${startDate} ]] || [[ -n ${endDate} ]]; then
        echo "$(logDate)$(basename $0): WARNING! For land-cover-change, only the difference for the 2010-2015 period is available"
	echo "$(logDate)$(basename $0)"': WARNING! The `--start-date` and `--end-date` arguments are ignored for '"${var}"
      fi
      # populate $files array
      files+=("$landcoverchangeFile")
      ;;

    # anything else
    *)
      echo "$(basename $0): WARNING! Invalid variable name"
      ;;
  esac
done

# check the length of $files array
if [[ ${#files[@]} == 0 ]]; then
  echo "$(basename $0): ERROR! No valid variable name(s) provided"
  exit 1;
fi

# empty array for complete file names
filesComplete=()
# populating filesComplete array
for f in "${files[@]}"; do
 filesComplete+=($(ls -d ${geotiffDir}/${f}* | xargs -n 1 basename))
done

# extracting the .zip files
echo "$(logDate)$(basename $0): Extracting Landsat .zip files under ${cache}"
for zipFile in "${filesComplete[@]}"; do
  # IMPORTANT: 7z is needed as a dependency
  7z e -y -bsp0 -bso0 "${geotiffDir}/${zipFile}"* -o${cache} *.tif -r
done

# list *.tif (not .tiff as per files' names)
tiffs=()
for tif in $cache/*.tif; do
  tiffs+=($(basename "${tif}"))
done

# extracting raster projection PROJ.4 string value
tempTif="${cache}/${tiffs[0]}"
rasterProj4="$(gdalsrsinfo "${tempTif}" | grep -e "PROJ.4" | cut -d ':' -f2)"

# if shapefile is provided extract the extents from it
if [[ -n $shapefile ]]; then
  # create latLims and lonLims variables specifying the limits of the ESRI Shapefile
  extract_shapefile_extents "${shapefile}" "${rasterProj4}"
fi

# subset and produce stats if needed
if [[ "${printGeotiff,,}" == "true" ]]; then
  # echo message 
  echo "$(logDate)$(basename $0): subsetting GeoTIFFs under $outputDir"
  
  for tif in "${tiffs[@]}"; do
    # subset based on lat and lon values
    subset_geotiff "${cache}/${tif}" "${outputDir}/${prefix}${tif}" "$latLims" "$lonLims"
  done
fi

## make R renv project directory
if [[ -n "$shapefile" ]] && [[ -n $stats ]]; then
  echo "$(logDate)$(basename $0): Extracting stats under $outputDir"
  mkdir -p "$cache/r-virtual-env/"
  ## make R renv in $cache
  virtualEnvPath="$cache/r-virtual-env/"
  cp "$(dirname $0)/../assets/renv.lock" "$virtualEnvPath"
  ## load necessary modules - excessive, mainly for clarification
  load_core_modules

  ## make the temporary directory for installing r packages
  tempInstallPath="$cache/r-packages"
  mkdir -p "$tempInstallPath"
  export R_LIBS_USER="$tempInstallPath"

  # extract given stats for each variable
  for tif in "${tiffs[@]}"; do
    IFS='.' read -ra fileName <<< "$tif"
    ## build renv and create stats
    Rscript "$(dirname $0)/../assets/stats.R" \
    	    "$tempInstallPath" \
  	    "$exactextractrCache" \
  	    "$renvPackagePath" \
	    "$virtualEnvPath" \
	    "$virtualEnvPath" \
	    "${virtualEnvPath}/renv.lock" \
	    "${cache}/${fileName[0]}.tif" \
	    "$shapefile" \
	    "$outputDir/${prefix}stats_${fileName[0]}.csv" \
	    "$stats" \
	    "$includeNA" \
	    "$quantiles" \
	    "$fid" >> "${outputDir}/${prefix}stats_${fileName[0]}.log" 2>&1; 
    wait;
  done
fi

# remove unnecessary files 
mkdir "$HOME/empty_dir" 
echo "$(logDate)$(basename $0): deleting temporary files from $cache"
rsync --quiet -aP --delete "$HOME/empty_dir/" "$cache"
rm -r "$cache"
echo "$(logDate)$(basename $0): temporary files from $cache are removed"
echo "$(logDate)$(basename $0): results are produced under $outputDir"

