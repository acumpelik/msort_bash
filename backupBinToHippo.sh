#!/bin/bash

# This is a script that backs up multiple recording days for an animal. Created on 2022-10-13 by Andrea.

# To run this script:
# cat baselist | xargs -n 1 ./binbackup.sh

# Note: I think xargs should run without me specfigying that -n 1, but it doesn't work now for some reason


animal="JC283"
rec_date=$1

echo "Backing up: "$rec_date

cd /adata1/data/$animal/$rec_date
rsync -av *[0-9].{bin,set} /hid1/data/databin/andrea/$animal/$rec_date

