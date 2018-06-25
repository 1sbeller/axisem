#!/bin/bash
#SBATCH -J 10/INTERP
#SBATCH --get-user-env
#SBATCH --nodes=5
#SBATCH --ntasks=120
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=1 
#SBATCH --time=00:25:00
#SBATCH --output INTERP
#SBATCH --constraint=HSW24 
#SBATCH --exclusive 

module purge
module load intel
module load intelmpi
ulimit -s unlimited
time srun --mpi=pmi2 -K1 -n $SLURM_NTASKS ./interpolate_3D_wavefield.x > OUTPUT_interp

