#!/bin/bash
# Created by Andrea, 2023-03-06
# Based loosely on Helo's preproc4_msrun. Runs MountainSort, assuming it has already been installed, e.g. using Pedya's environment, see https://github.com/zivadinac/phd_tools/tree/main/mountain_sort_pipeline. Make sure you've activated the ms_clust environment (run "conda activate ms_clust").
# Note: I am no longer running this in parallel, because large temporary files are generated that caused the disk to fill up quickly.

####################################### Command to run this file: ###########################################
# Takes two arguments as an input, recording_day and num_sessions. To run for a single day, run:
# ./msrun_in_series.sh [day] [num_sessions]
#
# To run in series, edit ms_series_args with the two input arguments (recording_day and num_sessions):
# cat ms_series_args | xargs -n 2 ./msrun_in_series.sh
#############################################################################################################

# Set parameters
animal="JC267"
nchan="128"
threshold=4

day=$1
num_sessions=$2
dir='/adata_clust/processing'

# cd to directory with Pedya's scripts:
cd ~/GitHub/phd_tools/mountain_sort_pipeline
echo "Now running MountainSort on:" $day
./run_ms_local $dir/$animal/$day $animal $day $threshold $nchan
