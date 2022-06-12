# Bash script that creates the processing folders for each recording day


animal="JC258"

# Bash key-value pairs where key: recording day date, value: total number of recording trials for that day
declare -A mydict
mydict["20210625"]=46
mydict+=(["20210626"]=46 ["20210627"]=46 ["20210628"]=46 ["20210629"]=46 ["20210701"]=46 ["20210702"]=46 ["20210704"]=46 ["20210705"]=46 ["20210706"]=46 ["20210717"]=46 ["20210718"]=46 ["20210720"]=46 ["20210721"]=46)


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
