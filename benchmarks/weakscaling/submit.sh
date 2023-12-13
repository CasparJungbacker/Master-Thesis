#!/bin/bash
#SBATCH --array=1,2,4,8
#SBATCH --partition=gpu
#SBATCH --ntasks=%a
#SBATCH --gpus=%a
#SBATCH --gpus-per-task=1
#SBATCH --output=output_%a.txt

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
export NAMOPTIONS=namoptions.00$((SLURM_ARRAY_TASK_ID))

cp $NAMOPTIONS $TMPDIR
cp $PROF_INP $TMPDIR/prof.inp.00$((SLURM_ARRAY_TASK_ID))
cp $LSCALE_INP $TMPDIR/lscale.inp.00$((SLURM_ARRAY_TASK_ID))

cd $TMPDIR

srun --mpi=pmix $DALES $NAMOPTIONS
