#!/bin/bash

for batchDir in $*
do
  if [[ ! -d $batchDir ]]; then
    continue
  fi
  echo "concatenating $batchDir"

  if [[ "$batchDir" == "" ]]; then
    echo "provide a batch directory"
    exit
  fi

  configs=`ls $batchDir`

  nets=`cat net_names.txt`
  for n in $nets; do
    cat $batchDir/*/$n*/results.csv > $batchDir/${n}.csv
  done
done
