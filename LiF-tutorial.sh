#!/bin/bash

#SBATCH --job-name=LiFtutorial
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH
module load hdf5  # adds path to LD_LIBRARY_PATH
module load netcdf-c  # adds path to LD_LIBRARY_PATH
module load netcdf-fortran  # adds path to LD_LIBRARY_PATH
# See QE Prerequisites
export LC_ALL=C

QEDIR=/scratch/sbranchett/yambo-evaluation/q-e-qe-7.2
YAMBODIR=${PWD}/yambo-5.2.0
export PATH=$PATH:$QEDIR/bin:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

# Reproducint this tutorial:
# https://www.yambo-code.eu/wiki/index.php/LiF

WORKDIR=${PWD}/LiF-tutorial
cd "$WORKDIR"
cd LiF/PWSCF
srun pw.x < inputs/scf.in > scf.out
srun pw.x < inputs/nscf.in > nscf.out
ls LiF.save       >  ${WORKDIR}/LiF-tutorial.log
echo "-o0o-"      >> ${WORKDIR}/LiF-tutorial.log
cd LiF.save
srun p2y         &>> ${WORKDIR}/LiF-tutorial.log
echo "-o0o-"      >> ${WORKDIR}/LiF-tutorial.log
ls SAVE           >> ${WORKDIR}/LiF-tutorial.log
cd "$WORKDIR"
mkdir -p LiF/Optics/YAMBO/SAVE
mv LiF/PWSCF/LiF.save/SAVE/* LiF/Optics/YAMBO/SAVE/
cd LiF/Optics/YAMBO
# Yambo initialisation
rm -f r-01_init_setup  # first tidy up
echo "-o0o-"                             >> ${WORKDIR}/LiF-tutorial.log
srun yambo -F Inputs/01_init -J 01_init &>> ${WORKDIR}/LiF-tutorial.log
echo "-o0o-"                             >> ${WORKDIR}/LiF-tutorial.log
grep "Fermi Level" r-01_init_setup       >> ${WORKDIR}/LiF-tutorial.log
grep "G-vectors" r-01_init_setup         >> ${WORKDIR}/LiF-tutorial.log

# Bethe-Salpeter equation for Excitons
echo "-o0o-"                             >> ${WORKDIR}/LiF-tutorial.log
srun yambo -F Inputs/06_BSE -J 06_BSE   &>> ${WORKDIR}/LiF-tutorial.log
echo "COMPLETED"                         >> ${WORKDIR}/LiF-tutorial.log

