# Run this AFTER preproc2.sh is over

# BEFORE RUNNING THIS CHANGE THE ANIMAL ID AND THE NUMBER OF TETRODES BELOW!

# RUN THIS SCRIPT AS USER DATA

animal="jc233"
num_tetrodes=32 

declare -A mydict
mydict["170220"]=56
mydict+=(["180220"]=46 ["190220"]=46 ["200220"]=46 ["210220"]=46 ["230220"]=47 ["240220"]=46 ["250220"]=46 ["260220"]=58 ["070320"]=44)


#MEC has little space, so this only copies one recording day at a time to convert to mda, then it runs different tetrodes in parallel at mec.

ssh data@mec "mkdir /temp_store/dat_to_mda/$animal"

for rec_date in ${!mydict[@]};
do
	#Copy files to mec and convert to mda
	echo "Started day" $rec_date
	num_trials=${mydict[$rec_date]}
	basename=$animal"-"$rec_date
	processfold=$rec_date

	cd /helo2/processing/$animal/$processfold

	ssh data@mec "mkdir /temp_store/dat_to_mda/$animal/$processfold; cp /temp_store/dat_to_mda/* /temp_store/dat_to_mda/$animal/$processfold"

	scp ./*.dat data@mec:/temp_store/dat_to_mda/$animal/$processfold
	scp ./*.par* data@mec:/temp_store/dat_to_mda/$animal/$processfold

	cd /helo2/processing/$animal
	echo $rec_date "copied to MEC. Starting conversion to mda."
	ssh data@mec "bash -s" < ./mec_processing.sh $rec_date $num_trials $animal $num_tetrodes
	echo $rec_date "converted to mda."
	
	#Copy files back and delete from mec
	cd ./$processfold
	scp -r data@mec:/temp_store/dat_to_mda/$animal/$processfold/* .
	ssh data@mec "rm -r /temp_store/dat_to_mda/$animal/$processfold"

	echo "Making tetrode-specific par files for day" $rec_date
	../tetpar.sh $basename

	echo "Done with" $rec_date

done

ssh data@mec "rm -r /temp_store/dat_to_mda/$animal"

# Send yourself an email informing you that everything's done :D
#mail -s "Mda Convertion Done!" hchiossi@ist.ac.at <<< "It is all done, Helo! The output was saved to the preproc3_"$basename".txt file"

