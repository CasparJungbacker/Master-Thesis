#!/bin/bash

for dir in */
do
  sbatch \
    --partition=rome \
    --time=00:30:00 \
    --ntasks=128 \
    --output=$dir/output_multi_cpu.txt \
    --export=CASE=$dir \
    submit-cpu.sh
done
