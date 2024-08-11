#!/bin/bash

function show_legend {
    echo "Log parser, usage: $0 mode"
    echo "  1  All entries sorted by response code"
    echo "  2  All unique IPs found in records"
    echo "  3  All requests with errors (response code - 4xx or 5xx)"
    echo "  4  All unique IPs that occur among failed requests"
    exit 1
}

function check {
    if [ $# -ne 1 ]; then
        echo "Error: parameter must be 1"
        show_legend
    fi
    re='^[1-4]$'
    if ! [[ $1 =~ $re ]]; then
        echo "Error: parameter must be a number from 1 to 4"
        show_legend
    fi
}

path=../04

function read {
    for (( i=1; i<6; i++ )); do
        cat $path/result_day$i.log
    done
}

check $@

case "$1" in
    1 )
        printf "%s" "$(read)" | sort -k8
;;
    2 )
        printf "%s" "$(read)" | awk '{print $1}' | uniq
;;
    3 )
        printf "%s" "$(read)" | awk '{print $9}' | grep '[4|5][0-9][0-9]'
;;
    4 )
        printf "%s" "$(read)" | awk '{print $1, $9}' | grep '[4|5][0-9][0-9]' | awk '{print $1}' | uniq
;;
esac