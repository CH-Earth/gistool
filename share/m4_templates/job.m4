`# messages'
echo "$(basename $0): Calling ${scriptName}.sh..."

`# run script'
srun ${script} \
  --cache="${cache}/cache-${__SLURM_JOB_ID__}"; 

