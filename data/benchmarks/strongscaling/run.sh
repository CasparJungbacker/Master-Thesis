#!/bin/bash

for i in 01 02 04 08 16
do
  let NODES=${i#0}/4
  if [[ ${NODES} -eq 0 ]]; then let NODES+=1; fi
  if [[ ${NODES} -gt 1 ]]; then let TASKS=4; else let TASKS=${i#0}; fi

  sbatch \
    --partition=gpu \
    --time=00:10:00 \
    --cpus-per-task=1 \
    --ntasks=$i \
    --ntasks-per-node=$TASKS \
    --gpus-per-node=$TASKS \
    --nodes=$NODES \
    --gpus=$i \
    --gpus-per-task=1 \
    --export=EXPNR="0$i" \
    --output=output_${i}.txt \
    submit.sh
done
