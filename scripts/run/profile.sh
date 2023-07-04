#!/bin/bash

source $HOME/source_nvidia.sh

DALES_EXEC=$HOME/Developer/build-NV-OpenACC-Debug/src/dales4.4
CASE_DIR=$HOME/my_labdata/test-dales-nv
NPROCS=1
FLAGS="-o profile-$(date '+%F_%H:%M:%S') --force-overwrite true"

cd ${CASE_DIR}
nsys profile ${FLAGS} mpirun -np ${NPROCS} ${DALES_EXEC} ./namoptions.001
