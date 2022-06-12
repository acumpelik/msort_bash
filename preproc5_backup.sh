#This script backs up your processed data in jozsef's format to hippo.
#Run this script as data to avoid having to input your password

animal=$1
rec_date=$2

echo $animal $rec_date

cd /helo3/processing/$animal/$rec_date

rsync -razv --exclude-from '/helo3/scripts/msort_bash/backup_exclude.txt' ./ data@hippo:/hid1/data/data/helo/$animal/$rec_date/

echo "Files .clu .res .fet .par .spk and .whl backed up to hippo"
