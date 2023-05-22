#!/bin/bash

source $HOME/source_nvidia.sh

export SYST=NV-OpenACC
BUILD_TYPE=$1

# NetCDF compiled with nVidia compilers
NETCDF_INCLUDE_DIR=$HOME/Software/netcdf/include
NETCDF_LIB=$HOME/Software/netcdf/lib

DALES_DIR="$HOME/Developer/dales-openacc/"
BUILD_DIR="$HOME/Developer/build-$SYST-$BUILD_TYPE/"


if [[ ! -d $BUILD_DIR ]]; then
    mkdir $BUILD_DIR
else
    # Empty the build directory
    if [[ ! "$(ls -A $BUILD_DIR)" ]]; then
        rm -rf $BUILD_DIR/*
    fi
fi
    
cd $BUILD_DIR
cmake $DALES_DIR -DNETCDF_INCLUDE_DIR=$NETCDF_INCLUDE_DIR -DNETCDF_C_LIB=$NETCDF_LIB/libnetcdf.a -DNETCDF_FORTRAN_LIB=$NETCDF_LIB/libnetcdff.a
make -j 8
