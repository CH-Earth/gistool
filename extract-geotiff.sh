#!/bin/bash
# GeoTIFF Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
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
# 1) Parts of the code are taken from https://www.shellscript.sh/tips/getopt/index.html
# 2) Parts of the code are taken from https://stackoverflow.com/a/17557904/5188208


# ================
# General comments
# ================
# 1) All variables are camelCased;


# ==============
# Help functions
# ==============
usage () {
  echo "GeoTIFF Dataset Processing Script

Usage:
  extract-geotiff [options...]

Script options:
  -d, --dataset				GeoTIFF dataset of interest, currently
                                        available options are: 'MODIS';
                                        'MERIT-Hydro';'SoilGridsV1';'SoilGridsV2';
  -i, --dataset-dir=DIR			The source path of the dataset file(s)
  -r, --crs=INT				The EPSG code of interest; optional
  					[defaults to 4326]
  -v, --variable=var1[,var2[...]]	If applicable, variables to process
  -o, --output-dir=DIR			Writes processed files to DIR
  -s, --start-date=DATE			If applicable, start date of the GeoTIFF
  					data; optional
  -e, --end-date=DATE			If applicable, end date of the GeoTIFF
  					data; optional
  -l, --lat-lims=REAL,REAL		Latitude's upper and lower bounds; optional
  -n, --lon-lims=REAL,REAL		Longitude's upper and lower bounds; optional
  -f, --shape-file=PATH			Path to the ESRI '.shp' file; optional
  -j, --submit-job			Submit the data extraction process as a job
					on the SLURM system; optional
  -a, --stat=stat1[,stat2[...]]	If applicable, extract the statistics of
  					interest, currently available options are:
					'min';'max';'mean';'majority';'minority';
					'median';'quantiles';'variety';'variance';
					'stdev';'coefficient_of_variation';'frac';
  -p, --prefix=STR			Prefix  prepended to the output files
  -c, --cache=DIR			Path of the cache directory; optional
  -E, --email=STR			E-mail when job starts, ends, and finishes; optional
  -V, --version				Show version
  -h, --help				Show this screen and exit

For bug reports, questions, discussions open an issue
at https://github.com/kasra-keshavarz/geotifftool/issues" >&1;

  exit 0;
}

short_usage () {
  echo "usage: $(basename $0) -d DATASET -io DIR -v var1[,var2,[...]] [-jVhtE] [-c DIR] [-se DATE] [-r INT] [-ln REAL,REAL] [-f PATH} [-p STR] [-a stat1[,stat2,[...]]] " >&1;
}

version () {
  echo "$(basename $0): version $(cat $(dirname $0)/VERSION)";
  exit 0;
}


# =====================
# Necessary Assumptions
# =====================
# TZ to be set to UTC to avoid invalid dates due to Daylight Saving
alias date='TZ=UTC date'

# expand aliases for the one stated above
shopt -s expand_aliases


# =======================
# Parsing input arguments
# =======================
# argument parsing using getopt - WORKS ONLY ON LINUX BY DEFAULT
parsedArguments=$(getopt -a -n extract-geotiff -o d:i:r:v:o:s:e:l:n:f:j:a:p:c:EVh --long dataset:,dataset-dir:,crs:,variable:,output-dir:,start-date:,end-date:,lat-lims:,lon-lims:,shape-file:,submit-job,stat:,prefix:,cache:,email:,version,help -- "$@")
validArguments=$?
# check if there is no valid options
if [ "$validArguments" != "0" ]; then
  short_usage;
  exit 1;
fi

# check if no options were passed
if [ $# -eq 0 ]; then
  short_usage;
  exit 1;
fi

# check long and short options passed
eval set -- "$parsedArguments"
while :
do
  case "$1" in
    -d | --dataset)       geotiff="$2"         ; shift 2 ;; # required
    -i | --dataset-dir)   geotiffDir="$2"      ; shift 2 ;; # required
    -r | --crs)		  crs="$2"	       ; shift 2 ;; # optional
    -v | --variable)	  variables="$2"       ; shift 2 ;; # required
    -o | --output-dir)    outputDir="$2"       ; shift 2 ;; # required
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # required
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # optional
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # optional
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # optional
    -f | --shape-file)	  shapefile="$2"       ; shift 2 ;; # optional
    -j | --submit-job)    jobSubmission=true   ; shift   ;; # optional
    -a | --stat)	  stat="$2"	       ; shift 2 ;; # optional
    -p | --prefix)	  prefixStr="$2"       ; shift 2 ;; # required
    -c | --cache)	  cache="$2"	       ; shift 2 ;; # optional
    -E | --email)	  email="$2"	       ; shift 2 ;; # optional
    -V | --version)	  version	       ; shift   ;; # optional 
    -h | --help)          usage                ; shift   ;; # optional

    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;

    # in case of invalid option
    *) echo "$(basename $0): invalid option '$1'" >$2;
       short_usage;
       exit 1;;
  esac
done

# check mandatory arguments whether provided
if [[ -z "${geotiffDir}" ]] || \
   [[ -z "${geotiff}"    ]] || \
   [[ -z "${variables}"  ]] || \
   [[ -z "${outputDir}"  ]] || \
   [[ -z "${prefixStr}"  ]]; then

   echo "$(basename $0): mandatory option(s) missing.";
   short_usage;
   exit 1;
fi

# if printGeotiff is not triggered
if [[ -z $printGeotiff ]]; then
  printGeotiff=false
fi

# default value for cache path if not provided as an argument
if [[ -z $cache ]] && [[ -n $jobSubmission ]]; then
  cache="$HOME/scratch/.temp_data_jobid"
elif [[ -z $cache ]]; then
  cache="$HOME/scratch/.temp_data_$(date +"%N")"
fi

# email withought job submission not allowed
if [[ -n $email ]] && [[ -z $jobSubmission ]]; then
  echo "$(basename $0): Email is not supported wihtout job submission;"
  echo "$(basename $0): Continuing without email notification..."
fi

# either shapefile or spatial extents arguments are allowed
if [[ -n $shapefile ]] && [[ -n $latLims ]]; then
  echo "$(basename $0): ERROR! Either shapefile or spatial extents should be entered"
  exit 1;
elif [[ -n $shapefile ]] && [[ -n $lonLims ]]; then
  echo "$(basename $0): ERROR! Either shapefile or spatial extents should be entered"
  exit 1;
fi

# if no crs is entered, assign the default value of EPSG 4326
if [[ -z $crs ]]; then
  crs=4326
fi


# ======================
# Necessary preparations
# ======================
# put necessary arguments in an array - just for legibility
declare -A funcArgs=([geotiffDir]="$geotiffDir" \
		     [crs]="$crs" \
		     [variables]="$variables" \
		     [outputDir]="$outputDir" \
		     [startDate]="$startDate" \
		     [endDate]="$endDate" \
		     [latLims]="$latLims" \
		     [lonLims]="$lonLims" \
		     [shapefile]="$shapefile" \
		     [jobSubmission]="$jobSubmission" \
		     [stats]="$stats" \
		     [prefixStr]="$prefixStr" \
		     [cache]="$cache" \
		    );


# =================================
# Template data processing function
# =================================
call_processing_func () {

  local script="$1" # script local path
  local chunkTStep="$2" # chunking time-frame periods

  local scriptName=$(echo $script | cut -d '/' -f 2) # script/geotiff name

  # prepare a script in string format
  # all processing script files must follow same input argument standard
  local scriptRun
  read -rd '' scriptRun <<- EOF
	bash ${script} --dataset-dir="${funcArgs[geotiffDir]}" --crs="${funcArgs[crs]}" --variable="${funcArgs[variables]}" --output-dir="${funcArgs[outputDir]}" --start-date="${funcArgs[startDate]}" --end-date="${funcArgs[endDate]}" --lat-lims="${funcArgs[latLims]}" --lon-lims="${funcArgs[lonLims]}" --shape-file="${funcArgs[shapefile]}" --stat="${funcArgs[stats]}" --prefix="${funcArgs[prefixStr]}" --cache="${funcArgs[cache]}"
	EOF

  # evaluate the script file using the arguments provided
  if [[ "${funcArgs[jobSubmission]}" == true ]]; then
    # chunk time-frame
    chunk_dates "$chunkTStep"
    local dateArrLen="$((${#startDateArr[@]}-1))"  # or $endDateArr
    # Create a temporary directory for keeping job logs
    mkdir -p "$HOME/scratch/.gdt_logs"
    # SLURM batch file
    sbatch <<- EOF
	#!/bin/bash
	#SBATCH --array=0-$dateArrLen
	#SBATCH --cpus-per-task=4
	#SBATCH --nodes=1
	#SBATCH --account=rpp-kshook
	#SBATCH --time=04:00:00
	#SBATCH --mem=8GB
	#SBATCH --job-name=GWF_${scriptName}
	#SBATCH --error=$HOME/scratch/.gdt_logs/GWF_%A-%a_err.txt
	#SBATCH --output=$HOME/scratch/.gdt_logs/GWF_%A-%a.txt
	#SBATCH --mail-user=$email
	#SBATCH --mail-type=BEGIN,END,FAIL

	$(declare -p startDateArr)
	$(declare -p endDateArr)
	tBegin="\${startDateArr[\${SLURM_ARRAY_TASK_ID}]}"
	tEnd="\${endDateArr[\${SLURM_ARRAY_TASK_ID}]}"

	echo "${scriptName}.sh: #\${SLURM_ARRAY_TASK_ID} chunk submitted."
	echo "${scriptName}.sh: Chunk start date is \$tBegin"
	echo "${scriptName}.sh: Chunk end date is   \$tEnd"
	
	srun ${scriptRun} --start-date="\$tBegin" --end-date="\$tEnd" --cache="${cache}-\${SLURM_ARRAY_JOB_ID}-\${SLURM_ARRAY_TASK_ID}"
	EOF
    # echo message
    echo "$(basename $0): job submission details are printed under ${HOME}/scratch/.gdt_logs"
 
  else
    eval "$scriptRun"
  fi
}


# ======================
# Checking Input GeoTIFF 
# ======================

case "${geotiff,,}" in
  # MERIT Hydro
  "merithydro" | "merit hydro" | "merit-hydro" | "merit_hydro")
    call_processing_func "$(dirname $0)/merit_hydro/merit_hydro.sh"
    ;;

  # Soil Grids v1
  "soil-grids-v1" | "soilgridsv1" | "soil_grids_v1" | "soil grids v1")
    call_processing_func "$(dirname $0)/soil_grids/soil_grids_v1.sh"
    ;;

  # Soil Grids v2
  "soil-grids-v2" | "soilgridsv2" | "soil_grids_v2" | "soil grids v2")
    call_processing_func "$(dirname $0)/soil_grids/soil_grids_v2.sh"
    ;;
  
  # MODIS
  "modis")
    call_processing_func "$(dirname $0)/modis/modis.sh"
    ;;

  # dataset not included above
  *)
    echo "$(basename $0): missing/unknown dataset";
    exit 1;;
esac

