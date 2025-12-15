#!/bin/bash
# GIS Data Processing Workflow
# Copyright (C) 2023-2025, University of Calgary
# Copyright (C) 2022, University of Saskatchewan
#
# This file is part of GIS Data Processing Workflow
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
  echo "usage: $(basename $0) -cio DIR -v var1[,var2[...]] [-r INT] [-se DATE] [-ln REAL,REAL] [-f PATH] [-F STR] [-t BOOL] [-a stat1[,stat2,[...]] [-q q1[,q2[...]]]] [-p STR] "
}


# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$( \
  getopt --alternative \
  --name "generic-tif" \
  -o i:o:v:r:s:e:l:n:f:F:t:a:u:q:p:c:L: \
  --long dataset-dir:,output-dir:,variable:, \
  --long crs:,start-date:,end-date:,lat-lims:, \
  --long lon-lims:,shape-file:,fid:, \
  --long print-geotiff:,stat:,include-na:, \
  --long quantile:,prefix:,cache:, \
  --long lib-path: -- "$@" \
)
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
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # redundant - added for compatibility
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # redundant - added for compatibility
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
if [[ -n "$startDate" ]] || [[ -n "$endDate" ]]; then
  echo "$(basename $0): ERROR! redundant argument (time extents) provided";
  exit 1;
fi

# check the prefix if not set
if [[ -z $prefix ]]; then
  prefix="generic_"
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
renvPackagePath="${renvCache}/renv_1.1.1.tar.gz" # renv_1.1.1 source path
gistoolPath="$(dirname $0)/../../../../../" # gistool's path 


# ==========================
# Necessary Global Variables
# ==========================


# =================
# Useful One-liners
# =================
# sorting a comma-delimited string of real numbers
sort_comma_delimited () { IFS=',' read -ra arr <<< "$*"; echo ${arr[*]} | tr " " "\n" | sort -n | tr "\n" " "; }

# log date format
logDate () { echo "($(date +"%Y-%m-%d %H:%M:%S")) "; }


# ================
# Useful functions
# ================

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
  local leftBottomLims # left bottom coordinates (min lon, min lat)
  local rightTopLims # top right coordinates (max lon, max lat)

  # global variables
  # - $sourceProj4

  # reading arguments
  local shapefilePath=$1
  local destProj4=$2

  # extract PROJ.4 string for $shapefilePath
  # sourceProj4=$(ogrinfo -al -so "$shapefilePath" | grep -e "PROJ.4" 2>/dev/null)
  sourceProj4=$(ogrinfo -al -so "$shapefilePath" | grep "PROJ\.4" | awk -F': ' '{print $2}')

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
    ogr2ogr \
      -s_srs "$sourceProj4" \
      -t_srs "$destProj4" \
      "${tempShapefile}" "${shapefilePath}";

      #-f "ESRI Shapefile" \
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
# subset GeoTIFFs
#
# Globals:
#   latLims: comma-delimited latitude
#            limits
#   lonLims: comma-delimited longitude
#            limits
#   sourceProj4: the extents projection
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

  # subset based on lat/lon in their given projection - flush to disk at 500MB
  GDAL_CACHEMAX=500
  gdal_translate --config GDAL_CACHEMAX 500 \
    -co COMPRESS="DEFLATE" \
    -co BIGTIFF="YES" \
    -projwin "$lonMin" "$latMax" "$lonMax" "$latMin" "${sourceVrt}" "${destPath}" \
    -projwin_srs "$sourceProj4" \
    > /dev/null;
}


# ===============
# Data Processing
# ===============
# Display info
echo "$(logDate)$(basename $0): processing generic GeoTIFF(s)..."

# Make the output directory
echo "$(logDate)$(basename $0): creating output directory under $outputDir"
mkdir -p "$outputDir" # making the output directory
mkdir -p "$cache" # making the cache directory

# Extracting the raster's projection info in `Proj4` format
rasterProj4=$(gdalsrsinfo -o proj4 "${geotiffDir}${variables[0]}" | tr -d '[\n]')

# If shapefile is provided extract the extents from it
if [[ -n $shapefile ]]; then
  # create latLims and lonLims variables specifying the limits of the ESRI Shapefile
  extract_shapefile_extents "${shapefile}" "${rasterProj4}"
else
  sourceProj4="EPSG:4326"
fi

# Subset and produce stats if needed
if [[ "$printGeotiff" == "true" ]]; then
  echo "$(logDate)$(basename $0): subsetting GeoTIFFs under $outputDir"
  for var in "${variables[@]}"; do
    # Subset based on lat and lon values
    subset_geotiff "${geotiffDir}/${var}" "${outputDir}/${prefix}${var}"
  done
fi

## Make R renv project directory
if [[ -n "$shapefile" ]] && [[ -n $stats ]]; then
  echo "$(logDate)$(basename $0): Extracting stats under $outputDir"
  mkdir -p "$cache/r-virtual-env/"
  ## Make R renv in $cache
  virtualEnvPath="$cache/r-virtual-env/"
  cp "${gistoolPath}/etc/renv/renv.lock" "$virtualEnvPath"

  ## Make the temporary directory for installing r packages
  tempInstallPath="$cache/r-packages"
  mkdir -p "$tempInstallPath"
  export R_LIBS_USER="$tempInstallPath"

  # Extract given stats for each variable
  for var in "${variables[@]}"; do
    varName="$(echo "$var" | cut -d '.' -f 1)"

    ## Build renv and create stats
    Rscript "${gistoolPath}/etc/scripts/stats.R" \
      "$tempInstallPath" \
      "$exactextractrCache" \
      "$renvPackagePath" \
      "$virtualEnvPath" \
      "$virtualEnvPath" \
      "${virtualEnvPath}/renv.lock" \
      "${geotiffDir}/${var}" \
      "$shapefile" \
      "$outputDir/${prefix}stats_${varName}.csv" \
      "$stats" \
      "$includeNA" \
      "$quantiles" \
      "$fid" >> "${outputDir}/${prefix}stats_${varName}.log" 2>&1;
  done
fi

# Remove unnecessary files 
mkdir "$HOME/empty_dir" 
echo "$(logDate)$(basename $0): deleting temporary files from $cache"
rsync --quiet -aP --delete "$HOME/empty_dir/" "$cache"
rm -r "$cache"
echo "$(logDate)$(basename $0): temporary files from $cache are removed"
echo "$(logDate)$(basename $0): results are produced under $outputDir"


