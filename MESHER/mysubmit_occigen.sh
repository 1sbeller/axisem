#!/bin/bash
#SBATCH -J MeshAxi
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --constraint=HSW24 
#SBATCH --output OUTPUT_AXISEM_MESH
#SBATCH --time=00:10:00
#SBATCH --mem=10000  
module purge
module load intel
module load intelmpi

ulimit -s unlimited
time srun --mpi=pmi2 -K1 -n $SLURM_NTASKS ./xmesh > OUTPUT 

