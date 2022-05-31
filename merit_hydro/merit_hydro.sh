#!/bin/bash
# GeoTIFF Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
# Copyright (C) 2021-22, Wouter Knoben
#
# This file is part of GeoTIFF Processing Workflow
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
#    developed mainly by Wouter Knoben (hence the header copyright credit). See the publication
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
  echo "usage: $(basename $0) [-io DIR] [-v VARS] [-se DATE] [-t CHAR] [-ln REAL,REAL]"
}

# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n extract-dataset -o i:v:o:s:e:t:l:n:c:p: --long geotiff-dir:,variables:,output-dir:,start-date:,end-date:,time-scale:,lat-lims:,lon-lims:,cache:,prefix: -- "$@")
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
    -i | --geotiff-dir)   geotiffDir="$2"      ; shift 2 ;; # required
    -v | --variables)     variables="$2"       ; shift 2 ;; # required
    -o | --output-dir)    outputDir="$2"       ; shift 2 ;; # required
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # redundant - added for compatibility 
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # redundant - added for compatibility
    -t | --time-scale)    timeScale="$2"       ; shift 2 ;; # required
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # required
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # required
    -c | --cache)         cacheDir="$2"        ; shift 2 ;; # required
    -p | --prefix)        prefix="$2"          ; shift 2 ;; # required

    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;

    # in case of invalid option
    *)
      echo "ERROR $(basename $0): invalid option '$1'";
      short_usage; exit 1 ;;
  esac
done

# check if dates are provided
if [[ -n "$startDate" ]] && [[ -n "$endDate" ]]; then
  echo "ERROR $(basename $0): redundant argument (date lims) provided";
  exit 1;
fi


# =====================
# Necessary Assumptions
# =====================
# The structure of file names is as follows: "VAR_(N|S)(STARTDEG)(W|E)(STARTDEG)" (no file extension)


# ===================
# Necessary Functions
# ===================
# Modules below available on Compute Canada (CC) Graham Cluster Server
load_core_modules () {
    module -q load gdal/3.0.4;
}
load_core_modules # load necessary modules

#######################################
# useful one-liners
#######################################


# ===============
# Data Processing
# ===============
# display info
echo "$(basename $0): processing MERIT Hydro GeoTIFF..."

# make the output directory
mkdir -p "$outputDir" # create output directory

# constructing the range of years
startYear=$(date --date="$startDate" "+%Y") # start year (first folder)
endYear=$(date --date="$endDate" "+%Y") # end year (last folder)
yearsRange=$(seq $startYear $endYear)

# constructing $toDate and $endDate in unix time EPOCH
toDate=$startDate
toDateUnix=$(date --date="$startDate" "+%s") # first date in unix EPOCH time
endDateUnix=$(date --date="$endDate" "+%s") # end date in unix EPOCH time

# extract the associated indices corresponding to latLims and lonLims
module -q load ncl/6.6.2
## min and max of latitude and longitude limits
minLat=$(echo $latLims | cut -d ',' -f 1)
maxLat=$(echo $latLims | cut -d ',' -f 2)
minLon=$(echo $lonLims | cut -d ',' -f 1)
maxLon=$(echo $lonLims | cut -d ',' -f 2)
## extract coord
coordIdx="$(ncl -nQ 'coord_file='\"$coordMainFile\" 'minlat='"$minLat" 'maxlat='"$maxLat" 'minlon='"$minLon" 'maxlon='"$maxLon" "$coordIdxScript")"
lonLimsIdx="$(echo $coordIdx | cut -d ' ' -f 1)"
latLimsIdx="$(echo $coordIdx | cut -d ' ' -f 2)"
module -q unload ncl/6.6.2
load_core_modules

# produce subsetted $coordFile as well
mkdir -p "$cacheDir"
coordFileSubset="${cacheDir}/coordFileSubset.nc"
# if subsetted coordinate file does not exist, make one
if [[ -f "$coordFileSubset" ]]; then
  :
else
  ncks -v "XLAT,XLONG" \
       -d "$latVar","$latLimsIdx" \
       -d "$lonVar","$lonLimsIdx" \
       "$coordEssFile" "$coordFileSubset" || true
fi

# for each year (folder) do the following calculations
for yr in $yearsRange; do

  # creating a temporary directory for temporary files
  echo "$(basename $0): creating cache files for year $yr in $cacheDir"
  mkdir -p "$cacheDir/$yr" # making the directory

  # setting the end point, either the end of current year, or the $endDate
  endOfCurrentYearUnix=$(date --date="$yr-01-01 +1year -1hour" "+%s") # last time-step of the current year
  if [[ $endOfCurrentYearUnix -le $endDateUnix ]]; then
    endPointUnix=$endOfCurrentYearUnix
  else
    endPointUnix=$endDateUnix
  fi

  # extract variables from the forcing data files
  while [[ "$toDateUnix" -le "$endPointUnix" ]]; do
    # date manipulations
    toDateFormatted=$(date --date "$toDate" "+$format") # current timestamp formatted to conform to CONUSI naming convention

    # creating file name
    file="${fileStruct}_${toDateFormatted}" # current file name

    # extracting variables from the files and spatial subsetting
    ncks -O -v "$variables" \
         -d "$latVar","$latLimsIdx" \
         -d "$lonVar","$lonLimsIdx" \
         "$datasetDir/$yr/$file" "$cacheDir/$yr/$file" & # extracting $variables
    [ $( jobs | wc -l ) -ge $( nproc ) ] && wait

    # increment time-step by one unit
    toDate=$(date --date "$toDate 1hour") # current time-step
    toDateUnix=$(date --date="$toDate" "+%s") # current timestamp in unix EPOCH time
  done

  # wait to make sure the while loop is finished
  wait

  # go to the next year if necessary
  if [[ "$toDateUnix" == "$endOfCurrentYearUnix" ]]; then 
    toDate=$(date --date "$toDate 1hour")
  fi

  # make the output directory
  mkdir -p "$outputDir/$yr/"

  # data files for the current year with extracted $variables
  files=($cacheDir/$yr/*)
  # sorting files to make sure the time-series is correct
  IFS=$'\n' files=($(sort <<<"${files[*]}")); unset IFS

  # check the $timeScale variable
  case "${timeScale,,}" in

    h)
      # going through every hourly file
      for f in "${files[@]}"; do
        # extracting information
        extract_file_info "$f"
        # necessary NetCDF operations
        generate_netcdf "${fileName}" "$fileNameDate" "$fileNameTime" "$cacheDir/$yr/" "$outputDir/$yr/" "$timeScale"
      done
      ;;

    d)
      # construct the date arrays
      populate_date_arrays 

      # for each date (i.e., YYYY-MM-DD)
      for d in "${uniqueDatesArr[@]}"; do
        # find the index of the $timesArr corresponding to $d -> $idx
        date_match_idx "$d" "1-3" "-" "${datesArr[@]}" 

        # concatenate hourly netCDF files to daily file, i.e., already produces _cat.nc files
	    dailyFiles=($cacheDir/$yr/${fileStruct}_${d}*)
	    concat_files "${fileStruct}_${d}" "$cacheDir/$yr/" "${dailyFiles[@]}" 

	    # implement CDO/NCO operations
	    generate_netcdf "${fileStruct}_${d}" "$d" "${timesArr[$idx]}" "$cacheDir/$yr/" "$outputDir/$yr/" "$timeScale"
      done
      ;;

    m)
      # construct the date arrays
      populate_date_arrays 

      # for each date (i.e., YYYY-MM-DD)
      for m in "${uniqueMonthsArr[@]}"; do
        # find the index of the $timesArr corresponding to $d -> $idx
        # $m is in 'YYYY-MM' format
        date_match_idx "$m" "1,2" "-" "${datesArr[@]}" 

        # concatenate hourly netCDF files to monthly files, i.e., already produced *_cat.nc files
        monthlyFiles=($cacheDir/$yr/${fileStruct}_${m}*)
        concat_files "${fileStruct}_${m}" "$cacheDir/$yr/" "${monthlyFiles[@]}" 

        # implement CDO/NCO operations
        generate_netcdf "${fileStruct}_${m}" "${datesArr[$idx]}" "${timesArr[$idx]}" "$cacheDir/$yr/" "$outputDir/$yr/" "$timeScale"
      done
      ;;

    y)
      # construct the date arrays
      populate_date_arrays

      # find the index of the $timesArr and $datesArr corresponding to $d -> $idx
      date_match_idx "$yr" "1" "-" "${datesArr[@]}"

      # concatenate hourly to yearly files - produced _cat.nc files
      yearlyFiles=($cacheDir/$yr/${fileStruct}_${yr}*)
      concat_files "${fileStruct}_${yr}" "$cacheDir/$yr/" "${yearlyFiles[@]}"

      # implement CDO/NCO operations
      generate_netcdf "${fileStruct}_${yr}" "${datesArr[$idx]}" "${timesArr[$idx]}" "$cacheDir/$yr/" "$outputDir/$yr/" "$timeScale"
      ;;

  esac
done

mkdir "$HOME/empty_dir"
echo "$(basename $0): deleting temporary files from $cacheDir"
rsync -aP --delete "$HOME/empty_dir/" "$cacheDir"
rm -r "$cacheDir"
echo "$(basename $0): temporary files from $cacheDir are removed"
echo "$(basename $0): results are produced under $outputDir"

