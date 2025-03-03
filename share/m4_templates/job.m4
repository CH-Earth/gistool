`# logging function'
logDate () { echo "($(date +"%Y-%m-%d %H:%M:%S")) "; }

# reading job configuration JSON
declare -A conf
while IFS="=" read -r key value; do
    conf["$key"]=$value
done < <(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' __CONF__)

`# messages'
echo "$(basename $0): Calling ${scriptName}.sh..."

`# run script'
srun ${scriptFile} \
  --cache="${cache}/cache-${__JOB_ID__}"; 

