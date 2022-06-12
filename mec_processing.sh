#!/bin/bash

# Run this AFTER preprocessing2.sh is over
# Run as user yosman on ca1 or as user data on mec. (That's where the conda clust envs have been created)

# BEFORE RUNNING THIS CHANGE THE ANIMAL ID AND THE NUMBER OF TETRODES BELOW!

# Assuming conda clust environment has already been created and all the packages required for mountainSort have already been installed. See /dyos/documents/Setting-up-things/preprocessing.odt for further info :)

# THE FOLDER PATHS USED HERE ARE IF YOU WANT TO RUN IT ON MEC

#Source activate clust #for a different conda version you may need to use 'conda activate clust'

#animal="jc233"
#num_tetrodes="32"

rec_date=$1
num_trials=$2
animal=$3
num_tetrodes=$4
N=6 #number of parallel processes on mec

processfold=$rec_date
basename=$animal-$rec_date

cd /temp_store/dat_to_mda/$animal/$processfold

for tet_id in `seq 1 $num_tetrodes`; #Go over all the tetrodes within the recording day. 
do
	((i=i%N)); ((i++==0)) && wait #limits to 6 parallel process at a time
	echo -e $processfold": Tetrode no."$tet_id"\n"
	echo "Starting dat to mda-ing" $processfold 
	./dat_to_mdab $basename $tet_id $num_trials &
	#echo "Done dat to mda-ing for: " $processfold "and tetrode number: " $tet_id 
done

exit
