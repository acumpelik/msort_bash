# Run this AFTER preprocessing2.sh is over
# Run as user yosman on ca1 or as user data on mec. (That's where the conda clust envs have been created)

# BEFORE RUNNING THIS CHANGE THE ANIMAL ID AND THE NUMBER OF TETRODES BELOW!

# Assuming conda clust environment has already been created and all the packages required for mountainSort have already been installed. See /dyos/documents/Setting-up-things/preprocessing.odt for further info :)

# THE FOLDER PATHS USED HERE ARE IF YOU WANT TO RUN IT ON MEC

#Source activate clust #for a different conda version you may need to use 'conda activate clust'

animal="jc225"
num_tetrodes=32 
threshold=5 #This is the spike extraction threshold

rec_date=$1 #In BASH $1 refers to the first argument passed
first_trial=$2 #In BASH $2 refers to the second argument passed
last_trial=$3

basename=$animal"-"$rec_date
processfold=$rec_date

ssh data@mec
mkdir /temp_store/dat_to_mda/$animal
mkdir /temp_store/dat_to_mda/$animal/$processfold

for tet_id in `seq 1 $num_tetrodes`; #Go over all the tetrodes within the recording day. 
do
	echo -e $processfold": Tetrode no."$tet_id"\n"
	#Step 1: Copying/moving programs to run all the mountainSort stuff
	cd /temp_store/dat_to_mda/$animal/$processfold	

	cp /temp_store/dat_to_mda/* .

        echo "Done copying the conversion scripts to folder: " $processfold 

	scp data@cofire:/helo1/processing/$animal/$processfold/*.dat .
	scp data@cofire:/helo1/data/processing/$animal/$processfold/*.par* .

        echo "Done copying dats to mec: " $processfold 

	# Step 2:
	echo "Starting dat to mda-ing" $processfold 
	./dat_to_mdab $processfold $tet_id $num_trials
	echo "Done dat to mda-ing for: " $processfold "and tetrode number: " $tet_id 
done

#Step 3: Deleting .dat and .par from mec
rm *.dat
rm *.par*

# Step 4: Copying files back
scp -R ./* data@cofire:/helo1/processing/$animal/$processfold
cd /temp_store/dat_to_mda
rm -R ./$animal/$processfold

#Exit mec and exit data user
exit
exit

cd /helo1/processing/$animal/$processfold/

for tet_id in `seq $first_trial $last_trial`; #Go over all the tetrodes within the recording day.
do
	#Step 5:
	echo "Starting mountainsorting" $processfold 
	# ./mount_sortb $tet_id $threshold
	echo "Done mountainsorting :" $processfold "and tetrode number: " $tet_id

	#Step 6:
	echo "Starting mountainsort to sgclust-ing" $processfold 
	# python3 mountain_to_sgclustb.py $tet_id $processfold
	echo "Done converting the mountainsort input to an sgclust compatible format: " $processfold "and tetrode number: " $tet_id 

	chmod -R 777 tet$tet_id/
# done | tee $1"_output.txt"
done

# Step 7: Send yourself an email informing you that everything's done :D
mail -s "Mountain Sorting Done!" hchiossi@ist.ac.at <<< "It is all done, Helo! The output was saved to the output_mountainsort_"$basename".txt file"

