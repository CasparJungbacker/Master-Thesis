#!/bin/bash

for dir in */
do
  sbatch \
    --partition=gpu \
    --time=00:05:00 \
    --ntasks=1 \
    --gpus-per-task=1 \
    --output=$dir/output_gpu.txt \
    --export=CASE=$dir \
    submit-gpu.sh
done
