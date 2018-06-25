#!/bin/bash
#SBATCH -J 10/RECON
#SBATCH --get-user-env
#SBATCH --nodes=4
#SBATCH --ntasks=96
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=1 
#SBATCH --time=00:30:00
#SBATCH --output RECON
#SBATCH --constraint=HSW24 
#SBATCH --exclusive 

module purge
module load intel
module load intelmpi
ulimit -s unlimited
time srun --mpi=pmi2 -K1 -n $SLURM_NTASKS ./reconstruct_3D_wavefield.x > OUTPUT_recon

