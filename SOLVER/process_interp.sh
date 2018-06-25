#!/bin/bash 

numsrc=$1
ttime=$2

cp Source_$numsrc/lithos.par lithos.par

echo "coupling_starttime_index        $ttime" >> lithos.par
echo "coupling_interp_stf             0 3000 0.05 fsource.bin"      >> lithos.par
echo "coupling_interp_filter          1 0.01 0.3" >> lithos.par
echo "coupling_axisem_nsim            4"             >> lithos.par
#echo "coupling_interp_rep              \"/scratch/cnt0028/mam7165/sbeller/Maupasacq\"" >> lithos.par
echo "coupling_interp_rep              \"/scratch/cnt0028/mam7165/sbeller/Maupasacq_10km\"" >> lithos.par

sed "s|monnom|$numsrc/INTERP|"    submit_interp.sh  > submit_interp3.sh

cd Source_${numsrc}
cp MZZ/simulation.info .
cp ../*.x .
cp ../submit_interp3.sh .
cp ../input_box* .
cp ../lithos.par .
cp /scratch/cnt0028/mam7165/sbeller/Maupasacq_10km/partition_info.txt .

#cp input_box* MXX_P_MYY/.
#cp input_box* MXY_MXX_M_MYY/.
#cp input_box* MXZ_MYZ/.
cp input_box* MZZ/.

sbatch submit_interp3.sh

cd ..


