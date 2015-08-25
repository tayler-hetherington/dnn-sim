#!/bin/bash

for batchDir in $*
do
  if [[ ! -d $batchDir ]]; then
    continue
  fi

  if [[ "$batchDir" == "" ]]; then
    echo "provide a batch directory"
    exit
  fi

  configs=`ls $batchDir`
  for c in $configs; do
    if [[ ! -d $batchDir/$c ]]; then
        continue
    fi
    param=`echo $c | cut -d '-' -f2`
    for f in $batchDir/$c/*/results.csv; do
        sed -i "s/\$/,$param/" $f
    done

    
  done
  

#cat $batchDir/*/$n*/results.csv > $batchDir/${n}.csv
done
