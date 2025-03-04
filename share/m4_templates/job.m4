
`# logging function'
logDate () { echo "($(date +"%Y-%m-%d %H:%M:%S")) "; }

# reading job configuration JSON
declare -A conf
while IFS="=" read -r key value; do
    conf["$key"]=$value
done < <(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' __CONF__)

`# messages'
echo "$(basename $0): Calling ${conf[scriptName]}.sh..."

`# run script'
eval ${conf[scriptFile]} \
  --dataset-dir="${conf[datasetDir]}" \
  --variable="${conf[variable]}" \
  --output-dir="${conf[outputDir]}" \
  --lat-lims="${conf[latLims]}" \
  --lon-lims="${conf[lonLims]}" \
  --shape-file="${conf[shapefile]}" \
  --prefix="${conf[prefix]}" \
  --start-date="${conf[startDate]}" \
  --end-date="${conf[endDate]}" \
  --cache="${conf[cache]}/cache-${__JOB_ID__}" \
  --lib-path"${conf[libPath]}";

