#!/bin/bash
HERE=~/Developer/mscthesis/benchmarks/walltime/wiske
TMP_DIR=~/my_scratch/tmp

DALES=~/my_labdata/build-gnu-fast-Release/src/dales4.4
PROF_INP=~/my_labdata/dales/cases/bomex/prof.inp.001
LSCALE_INP=~/my_labdata/dales/cases/bomex/lscale.inp.001

for dir in */
do
  # Copy input files
  CASE_DIR=$(pwd)/$dir
  mkdir $TMP_DIR
  cd $TMP_DIR
  cp {$PROF_INP,$LSCALE_INP,$CASE_DIR/namoptions.001} .

  # Run benchmark
  mpirun -np 8 $DALES ./namoptions.001 | tee output-cpu.txt
  cp output-cpu.txt $CASE_DIR

  # Clean up
  cd $HERE
  rm -rf $TMP_DIR
done
