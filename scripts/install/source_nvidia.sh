#!/bin/bash
YEAR=2023
NVHPC_INSTALL_DIR=$HOME/Software/nvidia/hpc_sdk
NVARCH=`uname -s`_`uname -m`; export NVARCH
NVCOMPILERS=$NVHPC_INSTALL_DIR; export NVCOMPILERS
MANPATH=$MANPATH:$NVCOMPILERS/$NVARCH/$YEAR/compilers/man; export MANPATH
PATH=$NVCOMPILERS/$NVARCH/$YEAR/compilers/bin:$PATH; export PATH
export PATH=$NVCOMPILERS/$NVARCH/$YEAR/comm_libs/mpi/bin:$PATH
export MANPATH=$MANPATH:$NVCOMPILERS/$NVARCH/$YEAR/comm_libs/mpi/man
export PATH=$NVCOMPILERS/$NVARCH/$YEAR/profilers/Nsight_Systems/bin:$PATH
#
# for cudecomp
#
export LD_LIBRARY_PATH=$NVHPC_INSTALL_DIR/$NVARCH/$YEAR/compilers/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NVHPC_INSTALL_DIR/$NVARCH/$YEAR/comm_libs/mpi/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NVHPC_INSTALL_DIR/$NVARCH/$YEAR/math_libs/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NVHPC_INSTALL_DIR/$NVARCH/$YEAR/comm_libs/nccl/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NVHPC_INSTALL_DIR/$NVARCH/$YEAR/comm_libs/nvshmem/lib:$LD_LIBRARY_PATH
#
# to fix some OpenACC/CUDA errors
#
#export UCX_MEMTYPE_CACHE=n
#
