#!/bin/bash

function show_legend {
    echo "Usage: $0 az az.az 3Mb"
    echo -e "\taz\t- list of letters of the English alphabet used in folder names (no more than 7 characters)."
    echo -e "\taz.az\t- list of letters used in the file name and extension (max 7 characters for name, max 3 characters for extension)."
    echo -e "\t3Mb\t- file size (in Megabytes, but not more than 100)."
    exit 1
}

function check_params {
    result=0
    if [[ $# -lt 3 ]]; then
        echo "Error: Missing options" >&2
        show_legend
    fi

    # param 1
    re='^[a-zA-Z]{1,7}$'
    if ! [[ $1 =~ $re ]]; then
        echo "Error: First parameter incorrect." >&2
        show_legend
    fi

    # param 2
    re='^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$'
    if ! [[ $2 =~ $re ]]; then
        echo "Error: Second parameter incorrect." >&2
        show_legend
    fi

    #param 3
    re='^[0-9]{1,3}[mM]b$'
    if ! [[ $3 =~ $re ]]; then
        echo "Error: The third parameter incorrect." >&2
        show_legend
    else
        size=${3:0:-2}
        if [ $size -gt 100 ]; then
            echo "Error: The third parameter more then 100Mb" >&2
            show_legend
        fi
    fi
}
