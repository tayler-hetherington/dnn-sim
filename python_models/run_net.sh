#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "usage: ./run_net.sh <name> <csv1> [csv2]..."
    exit
fi

name=$1
shift

outfile="results/${name}.csv"

if [ -f $outfile ]; then
    echo "$outfile exists"
    exit
fi

for csv in "$@"
do
    if [ -d $csv ]; then
        continue
    fi
    for lah in {1..5}
    do
        for las in {0..15}
        do
            #echo "python bubble_up.py $csv $las $lah"
            python bubble_up.py $csv $las $lah >> $outfile
            if [[ $? != 0 ]]; then
                # error or ctrl-c
                exit
            fi
        done
    done
done
