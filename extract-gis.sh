#!/bin/bash
# Geospatial Data Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
# Copyright (C) 2023-2024, University of Calgary
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
  echo "GISTOOL: Geospatial Data Processing Script

Usage:
  extract-gis [options...]

Script options:
  -d, --dataset				Geospatial dataset of interest
  -i, --dataset-dir=DIR			The source path of the dataset file(s)
  -r, --crs=INT				The EPSG code of interest; optional
  					[defaults to 4326]
  -v, --variable=var1[,var2[...]]	If applicable, variables to process
  -o, --output-dir=DIR			Writes processed files to DIR
  -s, --start-date=DATE			If applicable, start date of the geospatial
  					data; optional
  -e, --end-date=DATE			If applicable, end date of the geospatial
  					data; optional
  -l, --lat-lims=REAL,REAL		Latitude's upper and lower bounds; optional
  -n, --lon-lims=REAL,REAL		Longitude's upper and lower bounds; optional
  -f, --shape-file=PATH			Path to the ESRI '.shp' file; optional
  -F, --fid=STR				Column name representing elements of the
  					ESRI Shapefile to report statistics; optional
					defaults to the first column
  -j, --submit-job			Submit the data extraction process as a job
					on the SLURM system; optional
  -t, --print-geotiff=BOOL		Extract the subsetted GeoTIFF file; optional
  					[defaults to 'true']
  -a, --stat=stat1[,stat2[...]]		If applicable, extract the statistics of
  					interest, currently available options are:
					'min';'max';'mean';'majority';'minority';
					'median';'quantile';'variety';'variance';
					'stdev';'coefficient_of_variation';'frac';
					'coords'; 'count'; 'sum'; optional
  -U, --include-na			Include NA values in generated statistics;
  					optional 
  -q, --quantile=q1[,q2[...]]		Quantiles of interest to be produced if 'quantile'
  					is included in the '--stat' argument. The values
					must be comma delimited float numbers between
					0 and 1; optional [defaults to every 5th quantile]
  -p, --prefix=STR			Prefix  prepended to the output files
  -b, --parsable			Parsable SLURM message mainly used
  					for chained job submissions
  -c, --cache=DIR			Path of the cache directory; optional
  -E, --email=STR			E-mail when job starts, ends, and 
  					fails; optional
  -u, --account				Digital Research Alliance of Canada's sponsor's
  					account name; optional, defaults to 'rpp-kshook'
  -L, --lib-path			Path to the shared libraries needed; optional,
  					see the source code for the default path
  -V, --version				Show version
  -h, --help				Show this screen and exit

currently available datasets are:

    1) MERIT-Hydro (doi: 10.1029/2019WR024873)
    2) SoilGridsV1 (doi: 10.1371/journal.pone.0169748)
    3) Landsat (url: http://www.cec.org/north-american-land-change-monitoring-system/)
    4) gsde (doi: 10.1002/2013MS000293)
    5) depth-to-bedrock (doi: 10.1002/2016MS000686)
    6) MODIS (doi: 10.5067/MODIS/MCD12C1.061 and 10.5067/MODIS/MCD12Q1.006)
    7) soilclasses (doi: 10.4211/hs.1361509511e44adfba814f6950c6e742, based on Soil Grids v1)

For bug reports, questions, and discussions open an issue
at https://github.com/kasra-keshavarz/gistool/issues" >&1;

  exit 0;
}

short_usage () {
  echo "usage: $(basename $0) -d DATASET -io DIR -v var1[,var2,[...]] [-jVhEu] [-t BOOL] [-c DIR] [-se DATE] [-r INT] [-ln REAL,REAL] [-f PATH] [-F STR] [-p STR] [-a stat1[,stat2,[...]] [-q q1[,q2[...]]]] " >&1;
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
# argument parsing using getopt - 
# ATTENTION: `getopt` is available by default on most GNU/Linux 
#	     distributions, however, it may not work out of the
#	     box on MacOS or BSD
parsedArguments=$(getopt -a -n extract-geotiff -o d:i:r:v:o:s:e:l:n:f:F:jt:a:Uq:p:c:L:E:u:Vhb --long dataset:,dataset-dir:,crs:,variable:,output-dir:,start-date:,end-date:,lat-lims:,lon-lims:,shape-file:,fid:,submit-job,print-geotiff:,stat:,include-na,quantile:,prefix:,cache:,lib-path:,email:,account:,version,help,parsable -- "$@")
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
    -F | --fid)           fid="$2"             ; shift 2 ;; # optional
    -j | --submit-job)    jobSubmission=true   ; shift   ;; # optional
    -t | --print-geotiff) printGeotiff="$2"    ; shift 2 ;; # optional
    -a | --stat)	  stats="$2"	       ; shift 2 ;; # optional
    -U | --include-na)	  includeNA=true       ; shift	 ;; # optional
    -q | --quantile)	  quantiles="$2"       ; shift 2 ;; # optional
    -p | --prefix)	  prefixStr="$2"       ; shift 2 ;; # required
    -b | --parsable)	  parsable=true	       ; shift   ;; # optional
    -c | --cache)	  cache="$2"	       ; shift 2 ;; # optional
    -E | --email)	  email="$2"	       ; shift 2 ;; # optional
    -u | --account)	  account="$2"         ; shift 2 ;; # optional
    -L | --lib-path)	  libPath="$2"         ; shift 2 ;; # optional
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

# if $printGeotiff is not triggered
if [[ -z $printGeotiff ]]; then
  printGeotiff=true
fi

# if $includeNA is not triggered
if [[ -z $includeNA ]]; then
  includeNA=false
fi

# check the value of $printGeotiff
if [[ -n $printGeotiff ]]; then
  case "${printGeotiff,,}" in
    "true" | "1" )
      printGeotiff="true"
      ;;

    "false" | "0" )
      printGeotiff="false"
      ;;

    *)
      echo "$(basename $0): invalid value for '--print-geotiff', continuing with default value of 'true'"
      ;;
  esac
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

# parsable without job submission not allowed
if [[ -n $parsable ]] && [[ -z $jobSubmission ]]; then
  echo "$(basename $0): ERROR! --parsable argument cannot be used" \
  "without job submission"
    exit 1;
fi

# if parsable argument is provided
if [[ -n $parsable ]]; then
  parsable="--parsable"
else
  parsable=""
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

# at least $printGeotiff=true or $stats=stat1[,stat2[...]] must be provided
if [[ "${printGeotiff,,}" == "false" ]] && [[ -z $stats ]]; then
  echo "$(basename $0): ERROR! At minimum, either of '--print-geotiff' or '--stats' must be provided"
  exit 1;
fi

# if quantile is not given in '--stat' but '--quantile' is provided
if [[ "$stats" != *"quantile"* ]] && [[ -n $quantiles ]]; then
  echo "$(basename $0): ERROR! 'quantile' stat is not provided in '--stat' while '--quantile' argument is filled"
  exit 1;
fi

# if quantile is given in '--stat' but '--quantile' is not provided
if [[ "$stats" == *"quantile"* ]] && [[ -z $quantiles ]]; then
  echo "$(basename $0): Warning! 'quantile' stat is provided in '--stat' while '--quantile' is not filled;"
  echo "$(basename $0): Continuing with default values of 25th, 50th, and 75th quantiles"
  quantiles="0.25,0.50,0.75"
fi

# if account is not provided, use `rpp-kshook` as default
if [[ -z $account ]]; then
  account="rpp-kshook"
  if [[ -z $parsable ]]; then
    echo "$(basename $0): WARNING! --account not provided, using \`rpp-kshook\` by default."
  fi
fi

# `--lib-path` needs a default value if not provided
if [[ -z $libPath ]]; then
  libPath="/project/rpp-kshook/Climate_Forcing_Data/assets/r-envs/"
  if [[ -z $parsable ]]; then
    echo "$(basename $0): WARNING! --lib-path not provided, using default path"
    echo "                /project/rpp-kshook/Climate_Forcing_Data/assets/r-envs/"
  fi
fi

# if `--fid` is not provided
if [[ -z $fid ]] && [[ -n $stats  ]]; then
  fid='default'
  if [[ -z $parsable ]]; then
    echo "$(basename $0): WARNING! --fid not provided, using the first"
    echo "                column of the input ESRI Shapefile to report statistics"
  fi
fi


# ======================
# Necessary Preparations
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
		     [fid]="$fid" \
		     [jobSubmission]="$jobSubmission" \
		     [printGeotiff]="$printGeotiff" \
		     [stats]="$stats" \
		     [includeNA]="$includeNA" \
		     [quantiles]="$quantiles" \
		     [prefixStr]="$prefixStr" \
		     [libPath]="$libPath" \
		     [cache]="$cache" \
		    );


# =================================
# Template data processing function
# =================================
call_processing_func () {

  local script="$1" # script local path
  local chunkTStep="$2" # chunking time-frame periods

  local scriptName=$(basename $script | cut -d '.' -f 1) # script/geotiff name

  # prepare a script in string format
  # all processing script files must follow same input argument standard
  local scriptRun
  read -rd '' scriptRun <<- EOF
	bash ${script} --dataset-dir="${funcArgs[geotiffDir]}" --crs="${funcArgs[crs]}" --variable="${funcArgs[variables]}" --output-dir="${funcArgs[outputDir]}" --start-date="${funcArgs[startDate]}" --end-date="${funcArgs[endDate]}" --lat-lims="${funcArgs[latLims]}" --lon-lims="${funcArgs[lonLims]}" --shape-file="${funcArgs[shapefile]}" --fid="${funcArgs[fid]}" --print-geotiff="${funcArgs[printGeotiff]}" --stat="${funcArgs[stats]}" --include-na="${funcArgs[includeNA]}" --quantile="${funcArgs[quantiles]}" --prefix="${funcArgs[prefixStr]}" --cache="${funcArgs[cache]}" --lib-path="${funcArgs[libPath]}"
	EOF

  # evaluate the script file using the arguments provided
  if [[ "${funcArgs[jobSubmission]}" == true ]]; then
    # Create a temporary directory for keeping job logs
    logDir="$HOME/.gistool/"
    mkdir -p "$logDir" 
    # SLURM batch file
    sbatch <<- EOF
	#!/bin/bash
	#SBATCH --cpus-per-task=4
	#SBATCH --nodes=1
	#SBATCH --account=$account
	#SBATCH --time=04:00:00
	#SBATCH --mem=16000MB
	#SBATCH --job-name=GIS_${scriptName}
	#SBATCH --error=$logDir/GIS_%j_err.txt
	#SBATCH --output=$logDir/GIS_%j.txt
	#SBATCH --mail-user=$email
	#SBATCH --mail-type=BEGIN,END,FAIL
	#SBATCH ${parsable}

	srun ${scriptRun} --cache="${cache}-\${SLURM_JOB_ID}" 
	EOF
    # echo message
    if [[ -z parsable ]]; then
      echo "$(basename $0): job submission details are printed under ${logDir}"
    fi
 
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

  # MODIS
  "modis")
    call_processing_func "$(dirname $0)/modis/modis.sh"
    ;;

  # GSDE
  "gsde")
    call_processing_func "$(dirname $0)/gsde/gsde.sh"
    ;;
  
  # Depth to Bedrock
  "depth-to-bedrock" | "depth_to_bedrock" | "dtb" | "depth-to_bedrock" | "depth_to_bedrock")
    call_processing_func "$(dirname $0)/depth_to_bedrock/depth_to_bedrock.sh"
    ;;
  
  # Landsat
  "landsat" | "landast" )
    call_processing_func "$(dirname $0)/landsat/landsat.sh"
    ;;

  # soil_class
  "soil_class" )
    call_processing_func "$(dirname $0)/soil_class/soil_class.sh"
    ;;

  # NHM layers
  "nhm" | "tgf" | "gf" )
    call_processing_func "$(dirname $0)/nhm/nhm.sh"
    ;;

  # dataset not included above
  *)
    echo "$(basename $0): missing/unknown dataset";
    exit 1;;
esac

