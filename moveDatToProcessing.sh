#!/bin/bash

# This is a script that moves .dat, .axtrk, and .digbin files to the processing foler. Created on 2022-10-17 by Andrea.
# This already exists within preproc2_mkdat.sh, but sometimes I need to run it separately.

# To run this script:
# cat baselist | xargs -n 1 ./moveDatToProcessing

# Note: I think xargs should run without me specfigying that -n 1, but it doesn't work now for some reason

diskorigin="adata1"
diskdest="adata2" #where the data is being copied
animal="JC283"
rec_date=$1

echo "Moving .dat files for: "$rec_date

cd /$diskorigin/data/$animal/$rec_date
rsync -av *[0-9].{dat,axtrk,digbin} /$diskdest/processing/$animal/$rec_date;

# Run this after verifying that the files copied:
#rm *[0-9].dat /adata1/processing/$animal/$processfold;

