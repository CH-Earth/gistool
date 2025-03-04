#!/bin/bash
# Geospatial Data Processing Workflow
# Copyright (C) 2022, University of Saskatchewan
# Copyright (C) 2023-2025, University of Calgary
# Copyright (C) 2022-2025, gistool developers
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
  echo "GISTOOL: Static Data Processing Script

Usage:
  extract-gis [options...]

Script options:
  -d, --dataset                    Geospatial dataset of interest
  -i, --dataset-dir=DIR            The source path of the dataset file(s)
  -r, --crs=INT                    The EPSG code of interest; optional
                                   [defaults to 4326]
  -v, --variable=var1[,var2[...]]  If applicable, variables to process
  -o, --output-dir=DIR             Writes processed files to DIR
  -s, --start-date=DATE            If applicable, start date of the geospatial
                                   data; optional
  -e, --end-date=DATE              If applicable, end date of the geospatial
                                   data; optional
  -l, --lat-lims=REAL,REAL         Latitude's upper and lower bounds; optional
  -n, --lon-lims=REAL,REAL         Longitude's upper and lower bounds; optional
  -f, --shape-file=PATH            Path to the ESRI '.shp' file; optional
  -F, --fid=STR                    Column name representing elements of the
                                   Polygons to report statistics; optional
                                   [defaults to the first column]
  -j, --submit-job                 Submit the data extraction process as a job
                                   to HPC's scheduler; optional
  -t, --print-geotiff=BOOL         Extract the subsetted GeoTIFF file; optional
                                   [defaults to 'true']
  -a, --stat=stat1[,stat2[...]]		 If applicable, extract the statistics of
                                   interest, currently available options are:
                                   'min';'max';'mean';'majority';'minority';
                                   'median';'quantile';'variety';'variance';
                                   'stdev';'coefficient_of_variation';'frac';
                                   'coords'; 'count'; 'sum'; optional
  -U, --include-na                 Include NA values in generated
                                   statistics, optional 
  -q, --quantile=q1[,q2[...]]      Quantiles of interest to be produced if 'quantile'
                                   is included in the '--stat' argument. The values
                                   must be comma delimited float numbers between
                                   0 and 1; optional [defaults to every 5th quantile]
  -p, --prefix=STR                 Prefix  prepended to the output files
  -b, --parsable                   Parsable SLURM message mainly used
                                   for chained job submissions
  -c, --cache=DIR                  Path of the cache directory; optional
  -E, --email=STR                  E-mail when job starts, ends, and fails; optional
  -C, --cluster=JSON                JSON file detailing cluster-specific details
  -V, --version                    Show version
  -h, --help                       Show this screen and exit

For bug reports, questions, and discussions open an issue
at https://github.com/CH-Earth/gistool/issues" >&1;

  exit 0;
}

short_usage () {
  echo "Usage: $(basename $0) [ARGS] [options]

Try \`$(basename $0) --help\` for more options." >&1;
}

version () {
  echo "$(basename $0): version $(cat $(dirname $0)/VERSION)";
  exit 0;
}

# useful log date format function
logDate () { echo "($(date +"%Y-%m-%d %H:%M:%S")) "; }
logDirDate () { echo "$(date +"%Y%m%d_%H%M%S")"; }


# =====================
# Necessary Assumptions
# =====================
# TZ to be set to UTC to avoid invalid dates due to Daylight Saving
alias date='TZ=UTC date'

# expand aliases for the one stated above
shopt -s expand_aliases

# local paths
schedulersPath="$(dirname $0)/etc/schedulers/"
scriptPath="$(dirname $0)/share/m4_templates/" # core script path
recipePath="$(realpath $(dirname $0)/var/repos/builtin/recipes/)"


# =======================
# Parsing input arguments
# =======================
# argument parsing using getopt - 
parsedArguments=$( \
  getopt --alternative \
  --name "extract-dataset" \
  -o d:i:r:v:o:s:e:l:n:f:F:jt:a:Uq:p:c:E:C:Vhb \
  --long dataset:,dataset-dir:,crs:,variable:, \
  --long output-dir:,start-date:,end-date:,lat-lims:, \
  --long lon-lims:,shape-file:,fid:,submit-job, \
  --long print-geotiff:,stat:,include-na,quantile:, \
  --long prefix:,cache:,email:,cluster:, \
  --long version,help,parsable -- "$@" \
)

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
    -r | --crs)           crs="$2"             ; shift 2 ;; # optional
    -v | --variable)      variables="$2"       ; shift 2 ;; # required
    -o | --output-dir)    outputDir="$2"       ; shift 2 ;; # required
    -s | --start-date)    startDate="$2"       ; shift 2 ;; # required
    -e | --end-date)      endDate="$2"         ; shift 2 ;; # optional
    -l | --lat-lims)      latLims="$2"         ; shift 2 ;; # optional
    -n | --lon-lims)      lonLims="$2"         ; shift 2 ;; # optional
    -f | --shape-file)	  shapefile="$2"       ; shift 2 ;; # optional
    -F | --fid)           fid="$2"             ; shift 2 ;; # optional
    -j | --submit-job)    jobSubmission=true   ; shift   ;; # optional
    -t | --print-geotiff) printGeotiff="$2"    ; shift 2 ;; # optional
    -a | --stat)          stats="$2"           ; shift 2 ;; # optional
    -U | --include-na)    includeNA=true       ; shift   ;; # optional
    -q | --quantile)      quantiles="$2"       ; shift 2 ;; # optional
    -p | --prefix)        prefixStr="$2"       ; shift 2 ;; # required
    -b | --parsable)      parsable=true        ; shift   ;; # optional
    -c | --cache)         cache="$2"           ; shift 2 ;; # optional
    -E | --email)         email="$2"           ; shift 2 ;; # optional
    -C | --cluster)       cluster="$2"         ; shift 2 ;; # required
    -V | --version)       version              ; shift   ;; # optional 
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
   [[ -z "${cluster}"    ]] || \
   [[ -z "${prefixStr}"  ]]; then

   echo "$(basename $0): mandatory option(s) missing.";
   short_usage;
   exit 1;
fi

# ==================
# Basic dependencies
# ==================
# if cluster is not provided, exit with an error 
if [[ -z $cluster ]]; then
  echo "$(basename $0): ERROR! --cluster missing"
  exit 1
fi

# `jq' is the only basic dependency needed to run this file
# initialize the cluster-dependent settings
inits="$(jq -r '.modules.init | join("; ")' $cluster)"
if [[ -n "$inits" ]]; then
  eval $inits
fi

# ==============
# Routine checks
# ==============
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
      echo "$(basename $0): WARNING! invalid value for '--print-geotiff', assuming 'true'"
      ;;
  esac
fi

# default value for cache path if not provided as an argument
if [[ -z $cache ]] && [[ -n $jobSubmission ]]; then
  cache="$HOME/.temp_data_jobid"
elif [[ -z $cache ]]; then
  cache="$HOME/.temp_data_$(date +"%N")"
fi

# email withought job submission not allowed
if [[ -n $email ]] && [[ -z $jobSubmission ]]; then
  echo "$(basename $0): WARNING! Email not supported wihtout job submission;"
fi

# parsable without job submission not allowed
if [[ -n $parsable ]] && [[ -z $jobSubmission ]]; then
  echo "$(basename $0): WARNING! --parsable must accompany --submit-job"
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
  echo "$(basename $0): Warning! 'quantile' stat is provided without '--quantile'"
  echo "$(basename $0): Considering 25th, 50th, and 75th quantiles"
  quantiles="0.25,0.50,0.75"
fi

# if `--fid` is not provided
if [[ -z $fid ]] && [[ -n $stats  ]]; then
  fid='default'
  if [[ -z $parsable ]]; then
    echo "$(basename $0): WARNING! --fid not provided, assuming firstentry"
  fi
fi

#######################################
# Create m4 variable definitions to be
# used in m4 macro calls in CLI from 
# JSON objects
#
# Globals:
#   None
#
# Arguments:
#   1: JSON object
#
# Outputs:
#   A string in "-D__KEY__=$value"
#   format of all the fields of a JSON
#   object
#######################################
function json_to_m4_vars () {
  # local variables
  local json="$1"

  # echo the string using jq>1.6
  echo "$json" | jq -r \
    'to_entries |
     map(select(.value != null and .value != "")) |
     map(
         "-D" +
         "__" +
         (.key | tostring | ascii_upcase) +
         "__" + "=" +
         (.value | tostring)
     ) |
     join(" ")'
}


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
  [cluster]="$cluster" \
  [cache]="$cache" \
  [libPath]="$(jq -r '.["lib-path"]' $cluster)" \
)


# =================================
# Template data processing function
# =================================
function call_processing_func () {

  # input local variables
  local scriptFile="$1" # script local path

  # local variables with assignment 
  local scriptName=$(basename $scriptFile | cut -d '.' -f 1)
  local logDir="$HOME/.gistool/${scriptName}_$(logDirDate)/"

  # local variable without assignment
  local script
  local scheduler
  # local JSON variables
  local jobDirectiveJSON
  local schedulerJSON
  local JSON
  # local variables defining module information
  local jobModules
  local jobModulesInit
  # local m4 variables
  local jobDirectiveM4
  local jobScriptM4

  # make the $logDir if haven't been created yet
  mkdir -p $logDir


  # typical script to run for all recipes
  script=$(cat <<- EOF
	bash ${scriptFile} \
	--dataset-dir="${funcArgs[geotiffDir]}" \
	--crs="${funcArgs[crs]}" \
	--variable="${funcArgs[variables]}" \
	--output-dir="${funcArgs[outputDir]}" \
	--start-date="${funcArgs[startDate]}" \
	--end-date="${funcArgs[endDate]}" \
	--lat-lims="${funcArgs[latLims]}" \
	--lon-lims="${funcArgs[lonLims]}" \
	--shape-file="${funcArgs[shapefile]}" \
	--fid="${funcArgs[fid]}" \
	--print-geotiff="${funcArgs[printGeotiff]}" \
	--stat="${funcArgs[stats]}" \
	--include-na="${funcArgs[includeNA]}" \
	--quantile="${funcArgs[quantiles]}" \
	--prefix="${funcArgs[prefixStr]}" \
	--cache="${funcArgs[cache]}" \
	--lib-path="${funcArgs[libPath]}"
	EOF
	)

  # ==============================
  # Building relevant JSON objects
  # ==============================
  # scheduler information
  scheduler="$(
    jq -r \
      '.scheduler' $cluster \
    )"
  schedulerJSON="$(
    jq -r \
      '.environment_variables' ${schedulersPath}/${scheduler}.json \
    )"

  # job directives information
  jobDirectiveJSON="$(
    jq -n \
      --arg "scriptName" "$scriptName" \
      --arg "logDir" "$logDir" \
      --arg "email" "$email" \
      --arg "parsable" "$parsable" \
      --argjson "specs" "$(jq -r '.specs' $cluster)" \
      '$ARGS.named + $specs | del(.specs)' \
    )"

  # job script information
  jobScriptJSON="$(
    jq -n \
       --arg "scriptFile" "$scriptFile" \
       --arg "datasetDir" "${funcArgs[geotiffDir]}" \
       --arg "variable" "${funcArgs[variables]}" \
       --arg "outputDir" "${funcArgs[outputDir]}" \
       --arg "startDate" "${funcArgs[startDate]}" \
       --arg "endDate" "${funcArgs[endDate]}" \
       --arg "latLims" "${funcArgs[latLims]}" \
       --arg "lonLims" "${funcArgs[lonLims]}" \
       --arg "shapefile" "${funcArgs[shapefile]}" \
       --arg "prefix" "${funcArgs[prefixStr]}" \
       --arg "fid" "${funcArgs[fid]}" \
       --arg "printGeotiff" "${funcArgs[printGeotiff]}" \
       --arg "stat" "${funcArgs[stats]}" \
       --arg "includeNA" "${funcArgs[includeNA]}" \
       --arg "libPath" "${funcArgs[libPath]}" \
       --arg "quantile" "${funcArgs[quantiles]}" \
       --arg "cache" "${funcArgs[cache]}" \
      '$ARGS.named' \
    )"

  # job module init information - not JSON as echoed as is
  jobModulesInit="$(
    jq -r \
      '.modules.init[] | select(length > 0)' $cluster \
    )"

  # job module information - not JSON as echoed as is
  jobModules="$(
    jq -r \
      '.modules[] |
       select(length > 0) |
       select(type != "array")' $cluster \
    )"

  # evaluate the script file using the arguments provided
  if [[ "${funcArgs[jobSubmission]}" == true ]]; then
    # determining job script path
    local jobScriptPath="$logDir/job.${scheduler}"
    local jobConfPath="$logDir/job.json"

    # create JSON config file for final submission
    JSON="$( 
      jq -n \
        --argjson "jobscript" "$jobScriptJSON" \
        --argjson "jobdirective" "$jobDirectiveJSON" \
        --argjson "scheduler" "$schedulerJSON" \
        '$jobscript + 
         $jobdirective + 
         $scheduler' \
      )"
    # job submission mode
    # exporting job configurations as a JSON to the job $logDir
    echo "$JSON" > "$jobConfPath"

    # generating the submission script using m4 macros
    # m4 variables defined
    # m4 variables are in the following form: __VAR__
    jobDirectiveM4="$(json_to_m4_vars "$jobDirectiveJSON")"
    # append the main processing script using m4 macros
    jobScriptM4="-D__CONF__=$jobConfPath "
    jobScriptM4+="$(json_to_m4_vars "$schedulerJSON") "

    # create scheduler-specific job submission script
    # 1. job scheduler directives
    m4 ${jobDirectiveM4} ${schedulersPath}/${scheduler}.m4 > \
      ${jobScriptPath}

    # 2. module inititation, if applicable
    echo -e "\n${jobModulesInit}" >> "${jobScriptPath}"

    # 3. loading core modules, if applicable
    echo -e "\n${jobModules}" >> "${jobScriptPath}"

    # 4. main body of script
    m4 ${jobScriptM4} ${scriptPath}/job.m4 >> \
      ${jobScriptPath}

    # choose applicable scheduler and submit the job
    case "${scheduler,,}" in 
      "slurm")
        sbatch --export=NONE ${jobScriptPath} ;;
      "pbs")
        qsub ${jobScriptPath} ;;
      "lfs")
        bsub --env=none ${jobScriptPath} ;;
    esac

  else
    # interactive mode
    # load all the necessary modules
    mods="$( \
      jq -r \
        '.modules | 
        to_entries | 
        map(
          select(
            .value | 
            type != "array" and . != ""
            )
        ) | 
        map(.value) | 
        join(" && ")' \
      $cluster)"
    # initialize (if needed) and load modules
    eval "$mods"
    # run the recipe script here
    eval "${script}"

  fi
  # done
}


# ======================
# Checking Input GeoTIFF 
# ======================

case "${geotiff,,}" in
  # MERIT Hydro dataset
  "merithydro" | "merit hydro" | "merit-hydro" | "merit_hydro")
    call_processing_func "$recipePath/merit_hydro/merit_hydro.sh"
    ;;

  # Soil Grids version 1 dataset
  "soil-grids-v1" | "soilgridsv1" | "soil_grids_v1" | "soil grids v1")
    call_processing_func "$recipePath/soil_grids/soil_grids_v1.sh"
    ;;

  # MODIS various datasets
  "modis")
    call_processing_func "$recipePath/modis/modis.sh"
    ;;

  # Global Soil Dataset for Earth System Modelling (GSDE) dataset
  "gsde")
    call_processing_func "$recipePath/gsde/gsde.sh"
    ;;
  
  # Global Depth to Bedrock dataset
  "depth-to-bedrock" | "depth_to_bedrock" | "dtb" | "depth-to_bedrock" | "depth_to_bedrock")
    call_processing_func "$recipePath/depth_to_bedrock/depth_to_bedrock.sh"
    ;;
  
  # Commission for Environmental Cooperation (CEC) North American Land Cover
  # Monitoring System (NALCMS) Landsat-based (and MODIS-) dataset
  "landsat" | "landast" )
    call_processing_func "$recipePath/landsat/landsat.sh"
    ;;

  # Global USDA-NRCS Soil Texture Class Map based on Soil Grids Version 1
  # dataset
  "soil_class" )
    call_processing_func "$recipePath/soil_class/soil_class.sh"
    ;;

  # National Hydrology Model (NHM) static layers dataset
  "nhm" | "tgf" | "gf" )
    call_processing_func "$recipePath/nhm/nhm.sh"
    ;;

  # dataset not included above
  *)
    echo "$(basename $0): missing/unknown dataset";
    exit 1;;
esac

