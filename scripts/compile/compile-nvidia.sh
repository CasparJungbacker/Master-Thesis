#!/bin/bash

source $HOME/source_nvidia.sh

export SYST=NV-OpenACC
BUILD_TYPE=Debug

# NetCDF compiled with nVidia compilers
NETCDF_INCLUDE_DIR=$HOME/Software/netcdf/include
NETCDF_LIB=$HOME/Software/netcdf/lib

NVIDIA_LIB=$HOME/Software/nvidia/hpc_sdk/Linux_x86_64/2023/cuda/12.1
NVTX_LIB=$HOME/Software/nvidia/hpc_sdk/Linux_x86_64/2023/cuda/lib64

DALES_DIR="$HOME/Developer/dales-openacc/"
BUILD_DIR="$HOME/Developer/build-$SYST-$BUILD_TYPE/"

CMAKE_FLAGS="-DNETCDF_INCLUDE_DIR=$NETCDF_INCLUDE_DIR \
    -DNETCDF_C_LIB=$NETCDF_LIB/libnetcdf.a \
    -DNETCDF_FORTRAN_LIB=$NETCDF_LIB/libnetcdff.a \
    -DUSE_NVTX=True \
    -DCUDAToolkit_ROOT=$NVIDIA_LIB
    -DNVTX_LIB=${NVTX_LIB}"

if [[ ! -d $BUILD_DIR ]]; then
    mkdir $BUILD_DIR
else
    # Empty the build directory
    if [[ "$(ls -A $BUILD_DIR)" ]]; then
        rm -rf $BUILD_DIR/*
    fi
fi
    
cd $BUILD_DIR
cmake $DALES_DIR $CMAKE_FLAGS
make -j 16
