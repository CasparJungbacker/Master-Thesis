#!/bin/bash

export SYST=$1
BUILD_TYPE=$2

DALES_DIR="$HOME/Developer/dales-openacc/"
BUILD_DIR="$HOME/Developer/build-$SYST-$BUILD_TYPE/"

if [[ ! -d $BUILD_DIR ]]; then
    mkdir $BUILD_DIR
fi
    
cd $BUILD_DIR
cmake $DALES_DIR
make -j 8
