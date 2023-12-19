#!/bin/bash

module load 2022
module load foss/2022a
module load NVHPC/22.7
module load netCDF/4.9.0-gompi-2022a
module load netCDF-Fortran/4.6.1-NVHPC-22.7-CUDA-11.7.0

export NVHPC_HOME=${EBROOTNVHPC}/Linux_x86_64/2022
export LD_LIBRARY_PATH=${NVHPC_HOME}/math_libs/lib64:${NVHPC_HOME}/cuda/lib64:$LD_LIBRARY_PATH

source ${NVHPC_HOME}/comm_libs/hpcx/latest/hpcx-init.sh
hpcx_load

export OMPI_MCA_coll_hcoll_enable=0

export DALES=/home/cjungbacker/dales/build/gpu/dp/src/dales4.4
export PROF_INP=/home/cjungbacker/dales/cases/bomex/prof.inp.001
export LSCALE_INP=/home/cjungbacker/dales/cases/bomex/lscale.inp.001
export NAMOPTIONS=namoptions.$EXPNR # Use --export option to define EXPNR

cp $NAMOPTIONS $TMPDIR
cp $PROF_INP $TMPDIR/prof.inp.$EXPNR
cp $LSCALE_INP $TMPDIR/lscale.inp.$EXPNR

cd $TMPDIR

srun --mpi=pmix $DALES $NAMOPTIONS
