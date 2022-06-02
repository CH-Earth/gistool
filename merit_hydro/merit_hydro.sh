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
  echo "usage: $(basename $0) -cio DIR -v var1[,var2[...]] [-r INT] [-se DATE] [-t CHAR] [-ln REAL,REAL] [-f PATH] [-a stat1[,stat2,[...]]] [-t] [-p STR] "
}


# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n merit_hydro -o i:o:v:r:s:e:l:n:f:a:tp:c: --long dataset-dir:,output-dir:,variable:,crs:,start-date:,end-date:,lan-lims:,lon-lims:,shape-file:,stat:,print-geotiff,prefix:,cache: -- "$@")
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
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # redundant - added for compatibility
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # redundant - added for compatibility
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # required - could be redundant
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # required - could be redundant
    -f | --shape-file)    shapefile="$2"       ; shift 2 ;; # required - could be redundant
    -a | --stat)	  stats="$2"	       ; shift 2 ;; # required - could be redundant
    -t | --print-geotiff) printGeotiff="$2"    ; shift 2 ;; # required - could be redundant
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

# check if $ensemble is provided
if [[ -n "$startDate" ]] || [[ -n "$endDate" ]]; then
  echo "ERROR $(basename $0): redundant argument (time extents) provided";
  exit 1;
fi

# check the prefix if not set
if [[ -z $prefix ]]; then
  prefix="merit_hydro"
fi


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
# the structure of the original file names is as follows: "%{var}_%{s or n}%{lat}%{w or e}%{lon}.tar"


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


#######################################
# useful one-liners
#######################################
# MERIT-Hydro specific latitude limits
lat_extent () { echo "define merit_extent_lat (x) \
                      {if (x<0) { if (x%30 == 0) {return ((x/30)*30)} \
                      else {return (((x/30)-1)*30) }} \
                      else {return ((x/30)*30) } }; merit_extent_lat($1)" | bc; }

# MERIT-Hydro specific longitude limits
lon_extent () { echo "define merit_extent_lon (x) \
                      {return ((x/30)*30) }; \
                      merit_extent_lon($1)" | bc; }

# sorting a comma-delimited string of real numbers
sort_comma_delimited () { IFS=',' read -ra arr <<< "$*"; echo ${arr[*]} | tr " " "\n" | sort -n | tr "\n" " "; }

# MERIT-Hydro coordinate signs
lat_sign () { if (( $* < 0 )); then printf "s%02g\n" $(echo "$*" | tr -d '-'); else printf "n%02g\n" "$*"; fi; }
lon_sign () { if (( $* < 0 )); then printf "w%03g\n" $(echo "$*" | tr -d '-'); else printf "e%03g\n" "$*"; fi; }


#######################################
# Parse latitute/longitude limits
#
# Globals:
#   sortedArr: sorted ascendingly of
#	       the input numbers
#
# Arguments:
#   coordLims: comma-delimited string
#	       of real numbers
#   coordType: either `lat` or `lon`
#	       important for MERITHydro
#
# Outputs:
#   sequence of numbers echoed from an
#   array.
#######################################
parse_coord_lims () {
  # local variables
  local coordType="$1"
  shift # skipping the first argument
  local coordLims="$@"
  local limsSeq

  # parsing the input string
  IFS=' ' read -ra limsSorted <<< $(sort_comma_delimited "$coordLims")
  # creating sequence of numbers
  if [[ "$coordType" == "lat" ]]; then
    limSeq=($(seq $(lat_extent "${limsSorted[0]}") \
                  30 \
                  $(lat_extent "${limsSorted[1]}")) \
        )
  elif [[ "$coordType" == "lon" ]]; then
    limSeq=($(seq $(lon_extent "${limsSorted[0]}") \
                  30 \
                  $(lon_extent "${limsSorted[1]}")) \
        )
  fi
  # echoing the `limSeq`
  echo "${limSeq[@]}"
}


# ===============
# Data Processing
# ===============
# display info
echo "$(basename $0): processing MERIT-Hydro GeoTIFF(s)..."

# make the cache directory
echo "$(basename $0): creating cache directory under $cache"
mkdir -p "$cache"

# make the output directory
echo "$(basename $0): creating output directory under $outputDir"
mkdir -p "$outputDir" # making the output directory

echo "$(basename $0): results are produced under $outputDir."

