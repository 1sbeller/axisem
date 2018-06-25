#!/bin/bash

dossier=$1
mot=$2
npart=$3

#my_src[0]='03'
#my_src[1]='09'
#my_src[2]='10'
#my_src[3]='14'
#my_src[4]='15'
#my_src[5]='24'
#my_src[6]='33'
#my_src[7]='34'
#my_src[8]='42'
#my_src[9]='45'

mkdir -p $dossier
#for mot in `seq -w 01 46` #${my_src[*]} 
#while read mot tt
#do
    for j in `seq -w 0001 ${npart}`
    do
        mv -v Source_${mot}/incident_field_vel_${j} ${dossier}/incident_field${mot}_vel_${j}
        mv -v Source_${mot}/incident_field_tra_${j} ${dossier}/incident_field${mot}_tra_${j}
    done
#done < newsave_picks_axisem.txt

