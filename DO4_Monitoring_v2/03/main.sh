#!/bin/bash

. ./check.sh

check_params $@

case "$1" in
    1 )
        echo -n "Path to log file: "
        read path
        if ! [ -f $path ]; then
            echo "Error: Log file not exists."
            exit 1
        fi
        IFS=$'\n'
        for line in `cat $path`; do
            if [ -d `echo $line | cut -d, -f1` ]; then
                rm -rf `echo $line | cut -d, -f1` 2>/dev/null
            fi
        done
    ;;

    2 )
        echo -n "Start date  [e.g. 2001-02-03 04:05:06]: "
        read start_date
        check_date $start_date
        echo -n "Finish date [e.g. 2001-02-03 04:05:06]: "
        read end_date
        check_date $end_date
        find / -type f -newerct "$start_date" ! -newerct "$end_date" -exec rm -rf {} + 2>/dev/null
    ;;

    3 )
        echo -n "Input mask for files: "
        read file_mask
        find / -type f -name "${file_mask}" -exec rm -rf {} + 2>/dev/null
        find / -type d -name "${file_mask}" -exec rm -rf {} + 2>/dev/null
    ;;
esac

echo "Done"