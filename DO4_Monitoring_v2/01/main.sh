#!/bin/bash

. ./check.sh

function create_name {
    start_name=${1:0:-1}
    end_name=${1: -1}
    while [[ ${#start_name} -lt 3 ]]; do
        start_name=$start_name$end_name
    done
    for (( i=0; i<$2; i++ )); do
        start_name=$start_name$end_name
        echo ${start_name}_`date +'%d%m%y'`
    done
}

check_params $@

dirnames=$(create_name $3 $2)
filenames=$(create_name "${5%.*}" $4)
extension="${5##*.}"
size=$(( ${6:0:-2} * 1024 ))
date=`date +'%d.%m.%y %H:%M:%S'`
logfile=`date +'result_%d_%m_%y_%H_%M_%S.log'`
flag=0

for dir in $dirnames; do
    for file in $filenames; do
        if [ `df -k --output=avail / | tail -n +2` -le 1048576 ]; then
            flag=1
            break
        fi
        mkdir $1/$dir 2>/dev/null
        echo -e "$1/$dir, $date" >> $logfile
        path="$1/$dir/$file.$extension"
        dd if=/dev/urandom bs=$size count=1 > $path 2>/dev/null
        echo -e "$path, $date, $size bytes" >> $logfile
    done
    if [ $flag -eq 1 ]; then
        break
    fi
done