#!/bin/bash

for i in 1 2 4 8
do
  sbatch \
    --partition=gpu \
    --time=00:10:00 \
    --ntasks=$i \
    --gpus=$i \
    --gpus-per-task=1 \
    --export=EXPNR="00$i" \
    --output=output_${i}.txt \
    submit.sh
done
