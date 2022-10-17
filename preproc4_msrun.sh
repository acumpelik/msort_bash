# By Andrea Cumpelik, 2022-05-31
# Created because Helo's msort bash scripts were written before Igor wrote ms_run_and_adapt.sh
# Assuming conda clust environment has already been created and all the packages required for MountainSort have already been installed. See /dyos/documents/Setting-up-things/preprocessing.odt for further info :)
# Run this scrips as andrea user and make sure you're running the clust environment (run "conda activate clust")

########### Command to run this file:####################################
# cat parallel_process_args | xargs -n 2 -P 6 ./preproc4_msrun.sh       
#########################################################################

# -P x: x is the max number of processes you allow to run at a time
# -n x: Tells xargs that it should read the argument file two whitespace separated entries at a time.

######################################################################################################

# Change the animal ID below to the correct one, make the parallel_process_args file (File format: a file consisting of n lines with the recording date and the total number of recording sessions, separated by a space, for n recording days. You won't use the second argument in this script, but it's written so that I can reuse the file I made for previous preproc scripts.)
animal="JC258"
nchan=128
threshold=4

rec_date=$1 # in bash $1 refers to the first argument
num_sessions=$2 # second argument

# cd to the processing directory
cd /adata1/processing/$animal/$rec_date/

echo "Now running MountainSort on:" $rec_date
ms_run_and_adapt.sh $animal $rec_date $threshold $nchan

echo "MountainSort has been run on: " $rec_date

#mail -s "MountainSort done!" acumpeli@ista.ac.at <<< "MountainSort has been completed for"$animal"." # I would need to configure this
