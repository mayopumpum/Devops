#!/bin/bash

function check_param {
    if [ $# -ne 1 ]
    then
        echo "Usage: $0 /pathtodir/"
        exit 1
    fi
    if [ ${1: -1} != "/" ]
    then
        echo "Last symbol must be '/'"
        exit 1
    fi
}

function top5dir {
    echo
    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    count=0
    IFS=$'\n'
    for dir in `du -a $path | sort -nr | head -n 5`
    do
        count=$(( $count + 1 ))
        echo "$count - `echo $dir | awk '{printf "%s, %d B\n", $2, $1}'`"
    done    
}

function conf_files {
    echo
    echo "Configuration files (with the .conf extension) = `find $path -type f | grep .conf$ | wc -l`"
    echo "Text files = `find $path -type f | grep .txt$ | wc -l`"
    echo "Executable files = `find $path -type f -executable | wc -l`"
    echo "Log files (with the extension .log) = `find $path -type f | grep .log$ | wc -l`"
    echo "Archive files = `find $path -type f | grep -iE '\.zip$|\.tar$|\.tar.gz$|\.tar.bz2$|\.tar.xz$|\.tgz$|\.tbz2$|\.7z$|\.iso$|\.cpio$|\.a$|\.ar$' | wc -l`"
    echo "Symbolic links = `find $path -type l | wc -l`"
}

function top10files {
    echo
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    count=0
    for file in `find $path -type f -ls | awk '{print $7 " " $11}' | sort -nr | head -10`
    do
        count=$(( $count + 1 ))
        path_to_file=`echo $file | cut -d" " -f2`
        size=`ls -lh $path_to_file | cut -d" " -f5`
        extension="${path_to_file##*.}"
        echo "$count - $path_to_file, $size""B, $extension"
    done  
}

function top10execfiles {
    echo
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
    count=0
    for file in `find $path -type f -executable -ls | awk '{print $7 " " $11}' | sort -nr | head`
    do
        count=$(( $count + 1 ))
        path_to_file=`echo $file | cut -d" " -f2`
        size=`ls -lh $path_to_file | cut -d" " -f5`
        md5=`md5sum ${path_to_file} | awk '{ print $1 }'`
        echo "$count - $path_to_file, $size""B, $md5"
    done
}

params="$@"
check_param ${params[*]}
path=$1

num_of_dirs=`find $path -type d | wc -l`
num_of_dirs=$(($num_of_dirs - 1))
echo
echo "Total number of folders (including all nested ones) = $num_of_dirs"
top5dir
echo
num_of_files=`find $path -type f | wc -l`
echo "Total number of files = $num_of_files"
conf_files
top10files
top10execfiles
