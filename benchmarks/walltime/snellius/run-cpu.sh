#!/bin/bash

NCPU=1

if [ $NCPU = 1 ]; then
  NAME=single
else
  NAME=multi
fi

for dir in */
do
  sbatch \
    --partition=rome \
    --time=03:00:00 \
    --mem=120G \
    --ntasks=$NCPU \
    --output=$dir/output_${NAME}_cpu.txt \
    --export=CASE=$dir \
    submit-cpu.sh
done
