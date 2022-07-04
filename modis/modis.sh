#!/bin/bash
# GIS Data Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
# Copyright (C) 2021, Wouter Knoben
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
# 3. `merit_extent` function is adopted from: https://unix.stackexchange.com/a/168486/487495
#     and https://unix.stackexchange.com/a/385175/487495


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
  echo "usage: $(basename $0) -cio DIR -v var1[,var2[...]] [-r INT] [-se DATE] [-ln REAL,REAL] [-f PATH] [-t BOOL] [-a stat1[,stat2,[...]] [-q q1[,q2[...]]]] [-p STR] "
}


# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n merit_hydro -o i:o:v:r:s:e:l:n:f:t:a:q:p:c: --long dataset-dir:,output-dir:,variable:,crs:,start-date:,end-date:,lat-lims:,lon-lims:,shape-file:,print-geotiff:,stat:,quantile:,prefix:,cache: -- "$@")
validArguments=$?
if [ "$validArguments" != "0" ]; then
  short_usage;
  exit 1;
fi

# check if no options were passed
if [ $# -eq 0 ]; then
  echo "$(logDate)ERROR $(basename $0): arguments missing";
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
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # redundant - added for compatibility
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # redundant - added for compatibility
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # required - could be redundant
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # required - could be redundant
    -f | --shape-file)    shapefile="$2"       ; shift 2 ;; # required - could be redundant
    -t | --print-geotiff) printGeotiff="$2"    ; shift 2 ;; # required
    -a | --stat)	  stats="$2"	       ; shift 2 ;; # optional
    -q | --quantile)	  quantiles="$2"       ; shift 2 ;; # optional
    -p | --prefix)	  prefix="$2"          ; shift 2 ;; # optional
    -c | --cache)	  cache="$2"           ; shift 2 ;; # required

    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;

    # in case of invalid option
    *)
      echo "$(logDate)ERROR $(basename $0): invalid option '$1'";
      short_usage; exit 1 ;;
  esac
done

# check if $ensemble is provided
if [[ -n "$startDate" ]] || [[ -n "$endDate" ]]; then
  echo "$(logDate)ERROR $(basename $0): redundant argument (time extents) provided";
  exit 1;
fi

# check the prefix if not set
if [[ -z $prefix ]]; then
  prefix="merit_hydro"
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
# hard-coded paths
renvCache="/project/rpp-kshook/Climate_Forcing_Data/assets/r-envs/" # general renv cache path
exactextractrCache="${renvCache}/exact-extract-env" # exactextractr renv cache path
renvPackagePath="${renvCache}/renv_0.15.5.tar.gz" # renv_0.15.5 source path


# ==========================
# Necessary Global Variables
# ==========================
# the structure of the original file names is as follows: "%{var}_%{s or n}%{lat}%{w or e}%{lon}.tar"


# ===================
# Necessary Functions
# ===================
# Modules below available on Compute Canada (CC) Graham Cluster Server
load_core_modules () {
    module -q purge
    module -q load gcc/9.3.0
    module -q load r/4.1.2
    module -q load gdal/3.4.1
    module -q load udunits/2.2.28
    module -q load geos/3.10.2
    module -q load proj/9.0.0
}
load_core_modules


# =================
# Useful One-liners
# =================
# MERIT-Hydro specific latitude and longitude limits
merit_extent () { echo "define merit_extent_lat (x) \
                      {if (x<0) { if (x%30 == 0) {return ((x/30)*30)} \
                      else {return (((x/30)-1)*30) }} \
                      else {return ((x/30)*30) } }; \
		      merit_extent_lat($1)" | bc; }

# sorting a comma-delimited string of real numbers
sort_comma_delimited () { IFS=',' read -ra arr <<< "$*"; echo ${arr[*]} | tr " " "\n" | sort -n | tr "\n" " "; }

# MERIT-Hydro coordinate signs and digit style
lat_sign () { if (( $* < 0 )); then printf "s%02g\n" $(echo "$*" | tr -d '-'); else printf "n%02g\n" "$*"; fi; }
lon_sign () { if (( $* < 0 )); then printf "w%03g\n" $(echo "$*" | tr -d '-'); else printf "e%03g\n" "$*"; fi; }

# log date format
logDate () { echo "($(date +"%Y-%m-%d %H:%M:%S")) "; }


#######################################
# Parse latitute/longitude limits
#
# Globals:
#   sortedArr: sorted ascendingly array 
#	       of the input numbers
#
# Arguments:
#   coordLims: comma-delimited string
#	       of real numbers
#
# Outputs:
#   sequence of integers echoed from an
#   array.
#######################################
parse_coord_lims () {
  # local variables
  local coordLims="$@"
  local limsSeq
  local limSorted

  # parsing the input string
  IFS=' ' read -ra limsSorted <<< $(sort_comma_delimited "$coordLims")
  # creating sequence of numbers
  limSeq=($(seq $(merit_extent "${limsSorted[0]}") \
                30 \
                $(merit_extent "${limsSorted[1]}")) \
        )
  # echoing the `limSeq`
  echo "${limSeq[@]}"
}


#######################################
# extract original MERIT-Hydro `tar`s
# for the latitude and longitude exten-
# ts of interest.
#
# Globals:
#   None
#
# Arguments:
#   sourceDir: the path to the
#	       sourceDir
#   destDir: the path to the destinati-
#	     on
#   var: the name of the MERIT-Hydro
#        dataset variable; MUST be one
#        of the following: elv;dir;hnd
#	 upa;upg;wth
#
# Outputs:
#   untarred files produced under
#   `$destDir`
#######################################
extract_merit_tar () {
  # local variables
  local sourceDir="$1" # source path
  local destDir="$2" # destination path
  local var="$3" # MERIT-Hydro variable
  local lat # counter variable
  local lon # counter variable

  # create sequence of latitude and longitude values
  local latSeq=($(parse_coord_lims "$latLims"))
  local lonSeq=($(parse_coord_lims "$lonLims"))

  # if rectangular subset is requested
  for lat in "${latSeq[@]}"; do
    for lon in "${lonSeq[@]}"; do
      # strip-components to evade making 
      # folder separately for each tar file
      tar --strip-components=1 -xf "${sourceDir}/${var}/${var}_$(lat_sign ${lat})$(lon_sign ${lon}).tar" -C "${destDir}"
    done
  done
}


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
		 -projwin $lonMin $latMax $lonMax $latMin "${sourceVrt}" "${destPath}" \
		 > /dev/null;
}


# ===============
# Data Processing
# ===============
# display info
echo "$(logDate)$(basename $0): processing MERIT-Hydro GeoTIFF(s)..."

# make the cache directory
echo "$(logDate)$(basename $0): creating cache directory under $cache"
mkdir -p "$cache"

# make the output directory
echo "$(logDate)$(basename $0): creating output directory under $outputDir"
mkdir -p "$outputDir" # making the output directory

# extract shapefile extents if provided
if [[ -n $shapefile ]]; then
  IFS=' ' read -ra shapefileExtents <<< "$(ogrinfo -so -al "$shapefile" | sed 's/[),(]//g' | grep Extent)"
  # define $latLims and $lonLims from $shapefileExtents
  latLims="${shapefileExtents[2]},${shapefileExtents[5]}"
  lonLims="${shapefileExtents[1]},${shapefileExtents[4]}"
fi

# untar MERIT-Hydro files and build .vrt file out of them
# for each variable
echo "$(logDate)$(basename $0): untarring MERIT-Hydro variables under $cache"
for var in "${variables[@]}"; do
  # create temporary directories for each variable
  mkdir -p "$cache/$var"
  # extract the `tar`s
  extract_merit_tar "$geotiffDir" "${cache}/${var}" "$var"
  # make .vrt out of each variable's GeoTIFFs
  # ATTENTION: the second argument is not contained with quotation marks
  gdalbuildvrt "${cache}/${var}.vrt" ${cache}/${var}/*.tif -resolution highest -sd 1 > /dev/null
done

# subset and produce stats if needed
if [[ "$printGeotiff" == "true" ]]; then
  echo "$(logDate)$(basename $0): subsetting GeoTIFFs under $outputDir"
  for var in "${variables[@]}"; do
    # subset based on lat and lon values
    subset_geotiff "${cache}/${var}.vrt" "${outputDir}/${prefix}${var}.tif"
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
  
  # extract given stats for each variable
  for var in "${variables[@]}"; do
    ## build renv and create stats
    Rscript "$(dirname $0)/../assets/stats.R" \
  	    "$exactextractrCache" \
  	    "$renvPackagePath" \
	    "$virtualEnvPath" \
	    "$virtualEnvPath" \
	    "${virtualEnvPath}/renv.lock" \
	    "${cache}/${var}.vrt" \
	    "$shapefile" \
	    "$outputDir/${prefix}stats_${var}.csv" \
	    "$stats" \
	    "$quantiles" >> "${outputDir}/${prefix}stats_${var}.log" 2>&1;
  done
fi

# produce stats if required
mkdir "$HOME/empty_dir" 
echo "$(logDate)$(basename $0): deleting temporary files from $cache"
rsync --quiet -aP --delete "$HOME/empty_dir/" "$cache"
rm -r "$cache"
echo "$(logDate)$(basename $0): temporary files from $cache are removed"
echo "$(logDate)$(basename $0): results are produced under $outputDir"

