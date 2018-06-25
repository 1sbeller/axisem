#!/bin/bash
#SBATCH -J AxiSEM
#SBATCH --get-user-env
#SBATCH --nodes=4
#SBATCH --ntasks=96
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=1 
#SBATCH --time=02:00:00
#SBATCH --output AxiSEM
#SBATCH --constraint=HSW24 
#SBATCH --exclusive 

module purge
module load intel
module load intelmpi
ulimit -s unlimited
time srun --mpi=pmi2 -K1 -n $SLURM_NTASKS ./axisem > OUTPUT_Axisem

