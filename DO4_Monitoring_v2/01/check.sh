#!/bin/bash

function show_legend {
    echo "Usage: $0 /abs/path num_subfolders az num_subfiles az.az 3kb"
    echo -e "\t/abs/path      - absolute path"
    echo -e "\tnum_subfolders - number of subfolders"
    echo -e "\taz             - list of letters of the English alphabet used in folder names (no more than 7 characters)."
    echo -e "\tnum_subfiles   - number of files in each created folder."
    echo -e "\taz.az          - list of letters used in the file name and extension (max 7 characters for name, max 3 characters for extension)."
    echo -e "\t3kb            - file size (in kilobytes, but not more than 100)."
    exit 1
}

function is_number {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        return 1
    fi
}

function is_number_check {
    is_number $1
    if [ $? -eq 1 ]; then
        echo "Error: '$1' parameter not a number." >&2
        show_legend
    else
        if [ $1 -lt 1 ]; then
            echo "Error: '$1' incorrect." >&2
            show_legend
        fi
    fi
}

function check_params {
    result=0
    if [ $# -lt 6 ]; then
        echo "Error: Missing options" >&2
        show_legend
    fi

    # param 1
    if ! [ -e $1 ] || [ ${1:0:1} != "/" ]; then
        echo "Error: Path is incorrect." >&2
        show_legend
    fi

    # param 2
    is_number_check $2

    # param 3
    re='^[a-zA-Z]{1,7}$'
    if ! [[ $3 =~ $re ]]; then
        echo "Error: Third parameter incorrect" >&2
        show_legend

    fi

    # param 4
    is_number_check $4

    # param 5
    re='^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$'
    if ! [[ $5 =~ $re ]]; then
        echo "Error: Fifth parameter incorrect" >&2
        show_legend

    fi

    #param 6
    re='^[0-9]{1,3}[kK]b$'
    if ! [[ $6 =~ $re ]]; then
        echo "Error: The sixth parameter incorrect." >&2
        show_legend
    else
        size=${6:0:-2}
        if [ $size -gt 100 ]; then
            echo "Error: The sixth parameter more then 100kb" >&2
            show_legend
        fi
    fi
}