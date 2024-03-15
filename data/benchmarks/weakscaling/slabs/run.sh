#!/bin/bash

for i in 01 02 04 08 16 32 64
do
  let NODES=${i#0}/4
  if [[ ${NODES} -eq 0 ]]; then let NODES+=1; fi
  if [[ ${NODES} -gt 1 ]]; then let TASKS=4; else let TASKS=${i#0}; fi

  sbatch \
    --partition=gpu \
    --time=00:10:00 \
    --ntasks=$i \
    --gpus=$i \
    --nodes=$NODES \
    --gpu-bind=none \
    --export=EXPNR="0$i" \
    --output=output_${i}.txt \
    --mail-type=ALL \
    --mail-user=c.a.a.jungbacker@student.tudelft.nl \
    submit.sh
done
