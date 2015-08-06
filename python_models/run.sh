#!/bin/bash

source /localhome/juddpatr/caffe_rc

time for file in `cat filters.txt`; do
    /localhome/juddpatr/myroot/usr/bin/python script $file `cat args` >> results.csv
    if [[ $? != 0 ]]; then
        >&2 echo "script returned non zero" 
        exit
    fi
done

echo "job completed sucessfully"
