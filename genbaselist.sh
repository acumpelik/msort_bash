# Simple script to generate a BASELIST (list of all recording files for a recording day)
# Run from processing animal folder

# By Andrea 2022-10-13

animal="JC283"
rec_date=20220924
num_sessions=8

cd $rec_date

for i in `seq $num_sessions`;
do
	echo $animal"-"$rec_date"_0"$i >> BASELIST

done

