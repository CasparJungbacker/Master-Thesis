#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --partition=gpu
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=18
#SBATCH --gpus=1
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=c.a.a.jungbacker@student.tudelft.nl

module load 2022
module load foss/2022a
module load NVHPC/22.7
module load netCDF/4.9.0-gompi-2022a
module load netCDF-Fortran/4.6.1-NVHPC-22.7-CUDA-11.7.0

export NVHPC_HOME=${EBROOTNVHPC}/Linux_x86_64/2022
export LD_LIBRARY_PATH=${NVHPC_HOME}/comm_libs/nccl/lib:${NVHPC_HOME}/comm_libs/nvshmem/lib:${NVHPC_HOME}/math_libs/lib64:/${NVHPC_HOME}/cuda/lib64:$LD_LIBRARY_PATH

source ${NVHPC_HOME}/comm_libs/hpcx/latest/hpcx-init.sh
hpcx_load

export OMPI_MCA_coll_hcoll_enable=0

export DALES=/home/cjungbacker/dales/build/dp/src/dales4.4
export CASE=/home/cjungbacker/runs/gpu/bomex-1024

cp $CASE/{namoptions.001,lscale.inp.001,prof.inp.001} "$TMPDIR"
cd "$TMPDIR"
srun --mpi=pmix $DALES namoptions.001 | tee output.txt
cp "$TMPDIR"/output.txt /home/cjungbacker/output.txt
