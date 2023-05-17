#!/bin/bash

# Source the nvidia environment
source ${HOME}/source_nvidia.sh

# Installation directory
INSTDIR=${HOME}/Software/netcdf

# Compilers
export CC=nvcc
export CXX=nvc++
export FC=nvfortran
export F77=nvfortran

# Flags
export CPPFLAGS="-DNDEBUG"
export CFLAGS="-O2"
export FFLAGS="-O2 -w"

# Compile and install NetCDF-C
cd ${HOME}/netcdf-c-4.9.2
./configure --prefix=${INSTDIR} --disable-hdf5 --disable-dap --disable-shared --enable-static
make -j 8 all check install

# Set some more flags for NetCDF-Fortran
export CPPFLAGS=${CPPFLAGS}" -I${NCDIR}/include"
export LDFLAGS=${LDFLAGS}" -L${NCDIR}/lib"
export LD_LIBRARY_PATH=${NCDIR}/lib
export LIBS="-lnetcdf -lm -lsz -lxml2 -lcurl"

# Compile and install NetCDF-Fortran
cd ${HOME}/netcdf-fortran-4.5.4
./configure --prefix=${INSTDIR} --disable-shared
make -j 8 check install
