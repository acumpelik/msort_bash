# Bash script that creates the processing folders for each recording day


animal="JC283"

# Bash key-value pairs where key: recording day date, value: total number of recording trials for that day
declare -A mydict
mydict["20220909"]=46
mydict+=(["20220910"]=46 ["20220911"]=46 ["20220912"]=46 ["20220913"]=46 ["20220915"]=46 ["20220916"]=46 ["20220917"]=46 ["20220918"]=46 ["20220919"]=46 ["20220920"]=46 ["20220921"]=46 ["20220923"]=46 ["20220924"]=46)


#Step 1: Create the necessary folders in the processing folder
cd /adata1/processing/
mkdir -m777 $animal
cd /adata1/processing/$animal

for date in ${!mydict[@]}; 
do
    basename=$date
    processfold=$date
	mkdir -m777 $processfold
done

echo "Preproc1_mkdir.sh DONE."
echo "Please create the .par files before running preproc2_mkdat.sh"
