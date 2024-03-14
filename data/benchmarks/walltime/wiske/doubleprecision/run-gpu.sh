#!/bin/bash
source ~/source_nvidia.sh

HERE=~/Developer/mscthesis/data/benchmarks/walltime/wiske/doubleprecision
TMP_DIR=~/my_scratch/tmp

DALES=~/my_labdata/build-NV-OpenACC-Release/src/dales4.4
PROF_INP=~/my_labdata/dales/cases/bomex/prof.inp.001
LSCALE_INP=~/my_labdata/dales/cases/bomex/lscale.inp.001

for dir in */
do
  # Copy input files
  CASE_DIR=$(pwd)/$dir
  mkdir $TMP_DIR
  cd $TMP_DIR
  cp $PROF_INP prof.inp.002
  cp $LSCALE_INP lscale.inp.002
  cp $CASE_DIR/namoptions.002 .

  # Run benchmark
  mpirun -np 1 $DALES ./namoptions.002 | tee output_gpu.txt
  cp output_gpu.txt $CASE_DIR

  # Clean up
  cd $HERE
  rm -rf $TMP_DIR
done
