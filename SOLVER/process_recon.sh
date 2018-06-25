#!/bin/bash 

numsrc=$1

lat=`grep "latitude:"  Source_${numsrc}/CMTSOLUTION  |awk '{print $2}'`
lon=`grep "longitude:" Source_${numsrc}/CMTSOLUTION  |awk '{print $2}'`

cp lithos.par_template lithos.par

echo "coupling_box_file               input_box.txt" >> lithos.par
echo "coupling_src_latlon             $lat $lon"     >> lithos.par
echo "coupling_nb_proc_axisem         96"           >> lithos.par
echo "coupling_axisem_nsim            4"             >> lithos.par
#echo "coupling_interp_rep             \"/scratch/cnt0028/mam7165/sbeller/Maupasacq\"" >> lithos.par
echo "coupling_interp_rep             \"/scratch/cnt0028/mam7165/sbeller/Maupasacq_10km\"" >> lithos.par
sed "s|monnom|$numsrc/RECON|"    submit_recon.sh  > submit_recon3.sh

cd Source_${numsrc}
cp ../*.x .
cp ../submit_recon3.sh .
cp ../input_box* .
cp ../lithos.par .

cp input_box* MXX_P_MYY/.
cp input_box* MXY_MXX_M_MYY/.
cp input_box* MXZ_MYZ/.
cp input_box* MZZ/.

sbatch submit_recon3.sh

cd ..

