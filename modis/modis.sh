#!/bin/bash
# GeoTIFF Data Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
# Copyright (C) 2021, Wouter Knoben
#
# This file is part of GeoTIFF Data Processing Workflow
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
  echo "usage: $(basename $0) -cio DIR -v var1[,var2[...]] [-r INT] [-se DATE] [-ln REAL,REAL] [-f PATH] [-a stat1[,stat2,[...]]] [-t] [-p STR] "
}


# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n modis -o i:o:v:r:s:e:l:n:f:a:p:c: --long dataset-dir:,output-dir:,variable:,crs:,start-date:,end-date:,lat-lims:,lon-lims:,shape-file:,stat:,prefix:,cache: -- "$@")
validArguments=$?
if [ "$validArguments" != "0" ]; then
  short_usage;
  exit 1;
fi

# check if no options were passed
if [ $# -eq 0 ]; then
  echo "ERROR $(basename $0): arguments missing";
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
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # required
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # required
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # required - could be redundant
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # required - could be redundant
    -f | --shape-file)    shapefile="$2"       ; shift 2 ;; # required - could be redundant
    -a | --stat)	  stats="$2"	       ; shift 2 ;; # required - could be redundant
    -p | --prefix)	  prefix="$2"          ; shift 2 ;; # optional
    -c | --cache)	  cache="$2"           ; shift 2 ;; # required

    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;

    # in case of invalid option
    *)
      echo "ERROR $(basename $0): invalid option '$1'";
      short_usage; exit 1 ;;
  esac
done

# check the prefix if not set
if [[ -z $prefix ]]; then
  prefix="modis"
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


# ==========================
# Necessary Global Variables
# ==========================
# the structure of the original file names is as follows: "%{var}/%{Y}.01.01/%{tile}.hdf"


# ===================
# Necessary Functions
# ===================
# Modules below available on Compute Canada (CC) Graham Cluster Server
load_core_modules () {
    module purge
    module -q load gcc/9.3.0
    module -q load r
    module -q load gdal 
}
load_core_modules


# =================
# Useful One-liners
# =================
# sorting a comma-delimited string of real numbers
sort_comma_delimited () { IFS=',' read -ra arr <<< "$*"; echo ${arr[*]} | tr " " "\n" | sort -n | tr "\n" " "; }


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

  # subset based on lat/lon
  gdal_translate -projwin $lonMin $latMax $lonMax $latMin "${sourceVrt}" "${destPath}" > /dev/null
}


# ===============
# Data Processing
# ===============
# display info
echo "$(basename $0): processing MODIS dataset..."

# make the cache directory
echo "$(basename $0): creating cache directory under $cache"
mkdir -p "$cache"

# make the output directory
echo "$(basename $0): creating output directory under $outputDir"
mkdir -p "$outputDir" # making the output directory

# extract shapefile extents if provided
if [[ -n $shapefile ]]; then
  IFS=' ' read -ra shapefileExtents <<< "$(ogrinfo -so -al "$shapefile" | sed 's/[),(]//g' | grep Extent)"
  # define $latLims and $lonLims from $shapefileExtents
  latLims="${shapefileExtents[2]},${shapefileExtents[5]}"
  lonLims="${shapefileExtents[1]},${shapefileExtents[4]}"
fi

# make .vrt file for each year and reproject



# subset and produce stats if needed
echo "$(basename $0): subsetting GeoTIFFs under $outputDir"
for var in "${variables[@]}"; do
  # subset based on lat and lon values
  subset_geotiff "${cache}/${var}.vrt" "${outputDir}/${var}.tif"
done

# produce stats if required
mkdir "$HOME/empty_dir"
echo "$(basename $0): deleting temporary files from $cache"
rsync -aP --delete "$HOME/empty_dir/" "$cache"
rm -r "$cache"
echo "$(basename $0): temporary files from $cache are removed"
echo "$(basename $0): results are produced under $outputDir."

