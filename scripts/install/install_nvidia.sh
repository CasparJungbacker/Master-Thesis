#!/bin/bash
export NVHPC_SILENT=true
export NVHPC_INSTALL_TYPE=single
export NVHPC_INSTALL_DIR=$HOME/Software/nvidia/hpc_sdk
NVVERSION_A=23.3
NVVERSION_B=$(echo $NVVERSION_A | sed 's/\.//g')
CUDA_VERSION=multi
YEAR=2023
NVARCH=`uname -s`_`uname -m`
wget https://developer.download.nvidia.com/hpc-sdk/${NVVERSION_A}/nvhpc_${YEAR}_${NVVERSION_B}_${NVARCH}_cuda_${CUDA_VERSION}.tar.gz
tar xpzf nvhpc_${YEAR}_${NVVERSION_B}_${NVARCH}_cuda_${CUDA_VERSION}.tar.gz
./nvhpc_${YEAR}_${NVVERSION_B}_${NVARCH}_cuda_${CUDA_VERSION}/install
rm -rf nvhpc_${YEAR}_${NVVERSION_B}_${NVARCH}_cuda_${CUDA_VERSION}*
