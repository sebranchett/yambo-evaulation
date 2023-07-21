#!/bin/bash

#SBATCH --job-name=qe-make
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=02:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023rc1
module load openmpi
module load openblas
# module load hdf5
module load fftw
export CPATH=/apps/arch/2023rc1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/fftw-3.3.10-ltsfu6fub54vzqa64polif6jqx6e2zy5/include:$CPATH

# Just to be sure, see Prerequisites
export LC_ALL=C

WORKDIR=./q-e-qe-7.2
cd "$WORKDIR"

# srun make clean \
#     >  qe_make_output.log
srun make all \
    >  qe_make_output.log

