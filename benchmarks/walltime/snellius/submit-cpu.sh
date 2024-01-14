#!/bin/bash

module load 2022
module load foss/2022a
module load netCDF-Fortran/4.6.0-gompi-2022a

export DALES=/home/cjungbacker/dales/build/cpu/dp/src/dales4.4
export PROF_INP=/home/cjungbacker/dales/cases/bomex/prof.inp.001
export LSCALE_INP=/home/cjungbacker/dales/cases/bomex/lscale.inp.001
export NAMOPTIONS=namoptions.001 # Use --export option to define EXPNR

cp $CASE/$NAMOPTIONS $TMPDIR
cp $PROF_INP $TMPDIR/prof.inp.001
cp $LSCALE_INP $TMPDIR/lscale.inp.001

cd $TMPDIR

srun --mpi=pmix $DALES $NAMOPTIONS
