#!/bin/bash

# Step 1: load modules
module load 2022 CMake/3.23.1-GCCcore-11.3.0 foss/2022a NVHPC/22.7 netCDF/4.9.0-gompi-2022a

# Step 2: add compilers to path
export NVHPC_HOME=${EBROOTNVHPC}/Linux_x86_64/2022
source ${NVHPC_HOME}/comm_libs/hpcx/latest/hpcx-init.sh
hpcx_load

# Step 3: whatever this is
export OMPI_MCA_coll_hcoll_enable=0

# Step 4: set various paths
SRCDIR=${HOME}/tarballs/netcdf-fortran-4.6.1
INSTDIR=${HOME}/software/netcdf-fortran
NCDIR=${EBROOTNETCDF}

# Step 5: set environment variables
export CC=$(which mpicc)
export FC=$(which mpif90)
export LD_LIBRARY_PATH=${NCDIR}/lib:${LD_LIBRARY_PATH}
export CPP_FLAGS=-I${NCDIR}/include
export LD_FLAGS=-L${NCDIR}/lib

# Step 6: configuring
cd ${SRCDIR}
./configure --prefix=${INSTDIR} --disable-shared > config.log 2>&1 

# Step 7: installing
make -j 4 > config.log 2>&1
make install > config.log 2>&1
