#!/bin/bash

. ./check.sh

function create_name {
    start_name=${1:0:-1}
    end_name=${1: -1}
    while [ ${#start_name} -lt 4 ]; do
        start_name=$start_name$end_name
    done
    for (( i=0; i<$2; i++ )); do
        start_name=$start_name$end_name
        echo ${start_name}_`date +'%d%m%y'`
    done
}

function create_files {
    for dir in $dir_names; do
        mkdir $1/$dir 2>/dev/null
        echo -e "$1/$dir, dir" >> $logfile
        file_names=$(create_name ${2%.*} $(( 1 + $RANDOM % 100)))
        for file in $file_names; do
            size_disk=`df -Th / | awk 'NR == 2{print $5}'`
            size_disk=${size_disk%G}
            if [[ $size_disk -le 1 ]]; then
                echo " "
                return 1
            fi
            path="$1/$dir/$file.$extension"
            dd if=/dev/urandom bs=$size count=1 > $path 2>/dev/null
            echo -e "$path, $date, $size bytes" >> $logfile
        done
    done
}

check_params $@

size_disk=`df -Th /`
size_disk=${size_disk%G}
dir_names=$(create_name $1 $(( 1 + $RANDOM % 100)))
dir_len=`echo $dir_names | wc -w`
extension=${2##*.}
size=$(( ${3:0:-2} * 1024 * 1024 ))
date=`date +'%d.%m.%y %H:%M:%S'`
logfile=`date +'result_%d_%m_%y_%H_%M_%S.log'`
start_time=`date +%s`
started=`date +'%Y-%m-%d %T'`
root_dirs=($(find / -maxdepth 3 -type d -writable 2>/dev/null | grep -v bin | grep -v sbin | grep -v snap | grep -v 'dev' | grep -v 'run'))
root_dirs_len=${#root_dirs[@]}

while : ; do
    root=${root_dirs[$RANDOM % $root_dirs_len]}
    if  [ -e $root ]; then
        create_files $root $2
        if [ $? -eq 1 ]; then
            break
        fi
    fi
done

finish_time=`date +%s`
finished=`date +'%Y-%m-%d %T'`

echo "Started: $started"
echo "Finished: $finished"
echo "Total: $(( $finish_time - $start_time )) seconds."

echo -e "Started: $started" >>$logfile
echo -e "Finished: $finished" >>$logfile
echo -e "Total: $(( $finish_time - $start_time )) seconds." >>$logfile