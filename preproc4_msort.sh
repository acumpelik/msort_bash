# Assuming conda clust environment has already been created and all the packages required for mountainSort have already been installed. See /dyos/documents/Setting-up-things/preprocessing.odt for further info :)

# RUN THIS SCRIPT AS ANDREA USER and before running make sure you are on clust environment

#Source activate clust #for a different conda version you may need to use 'conda activate clust'

animal="JC274"
num_tetrodes=32 
threshold=4 #This is the spike extraction threshold

rec_date=$1 #In BASH $1 refers to the first argument passed
num_trials=$2

basename=$animal"-"$rec_date
processfold=$rec_date

cd /adata1/processing/$animal/$processfold/

for tet_id in `seq 1 $num_tetrodes`; #Go over all the tetrodes within the recording day.
do
	#Step 5:
	echo "Starting mountainsorting" $processfold 
	../mount_sortb $tet_id $threshold
	echo "Done mountainsorting :" $processfold "and tetrode number: " $tet_id

	#Step 6:
	echo "Starting mountainsort to sgclust-ing" $processfold 
	python3 ../mountain_to_sgclustb.py $tet_id $processfold
	echo "Done converting the mountainsort input to an sgclust compatible format: " $processfold "and tetrode number: " $tet_id 

	#chmod -R 777 tet$tet_id/
done | tee $1"_output.txt"
#done

# Step 7: Send yourself an email informing you that everything's done :D

