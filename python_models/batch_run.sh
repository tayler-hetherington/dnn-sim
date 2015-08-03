#!/bin/bash

N_CPU=`cat /proc/cpuinfo | grep processor -c`

((N_CPU--)) # save one "core" for other stuff

declare -a jobs=(
"./run_net.sh vgg19_8bit filters/csv_8bits/VGG19*"
"./run_net.sh vgg19_7bit filters/csv_7bits/VGG19*"
"./run_net.sh googlenet_8bit filters/csv_8bits/google*"
"./run_net.sh googlenet_7bit filters/csv_7bits/google*"
"./run_net.sh alexnet_7bit filters/csv_7bits/alexnet*"
"./run_net.sh alexnet_8bit filters/csv_8bits/alexnet*"
"./run_net.sh cnn_m_7bit filters/csv_7bits/CNN_M*"
"./run_net.sh cnn_s_7bit filters/csv_7bits/CNN_S*"
"./run_net.sh flickr_7bit filters/csv_7bits/flickr*"
"./run_net.sh hybridcnn_7bit filters/csv_7bits/hybrid*"
"./run_net.sh placescnn_7bit filters/csv_7bits/places*"
"./run_net.sh rcnn_7bit filters/csv_7bits/rcnn*"
"./run_net.sh cnn_m_8bit filters/csv_8bits/CNN_M*"
"./run_net.sh cnn_s_8bit filters/csv_8bits/CNN_S*"
"./run_net.sh flickr_8bit filters/csv_8bits/flickr*"
"./run_net.sh hybridcnn_8bit filters/csv_8bits/hybrid*"
"./run_net.sh placescnn_8bit filters/csv_8bits/places*"
"./run_net.sh rcnn_8bit filters/csv_8bits/rcnn*"
)

for ((i = 0; i < ${#jobs[@]}; i++))
do
    echo "launching ${jobs[i]}"
    ${jobs[i]} &
    wait_start=1
    while true; do
        proc_count=`ps | grep -v grep | grep "run_net.sh" -c`
        if (( proc_count < N_CPU )); then
            break
        fi
        if [[ $wait_start == 1 ]]; then
            echo "waiting for free CPU"
            wait_start=0
        fi
        sleep 1s
    done
done
