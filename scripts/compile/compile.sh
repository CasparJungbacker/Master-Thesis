#!/bin/bash

export SYST=gnu-fast
BUILD_TYPE=Debug

DALES_DIR="$HOME/Developer/dales-openacc/"
BUILD_DIR="$HOME/Developer/build-$SYST-$BUILD_TYPE/"

if [[ ! -d $BUILD_DIR ]]; then
    mkdir $BUILD_DIR
else
    # Empty the build directory
    if [[ "$(ls -A $BUILD_DIR)" ]]; then
        rm -rf $BUILD_DIR/*
    fi
fi
    
cd $BUILD_DIR
cmake $DALES_DIR
make -j 8
