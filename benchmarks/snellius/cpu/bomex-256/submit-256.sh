#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --partition=thin
#SBATCH --ntasks=32
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=c.a.a.jungbacker@student.tudelft.nl

module load 2022
module load foss/2022a
module load netCDF-Fortran/4.6.0-gompi-2022a

export DALES=/home/cjungbacker/dales/build/cpu/dp/src/dales4.4
export CASE=/home/cjungbacker/runs/cpu/bomex-256

cp $CASE/{namoptions.001,lscale.inp.001,prof.inp.001} "$TMPDIR"
cd "$TMPDIR"
srun --mpi=pmix $DALES namoptions.001 | tee output.txt
cp "$TMPDIR"/output.txt $CASE/output.txt
