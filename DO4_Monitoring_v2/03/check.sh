#!/bin/bash

function show_legend {
    echo "Log cleaner, usage: $0 mode"
    echo -e "  1  According to the log file."
    echo -e "  2  By creation date and time."
    echo -e "  3  By name mask (ie symbols, underscore and date)."
    exit 1
}

function check_date {
    re='^(199[0-9]|20[0-2][0-3])\-(0[1-9]|1[0-2])\-(0[1-9]|[12][0-9]|3[01])$'
    if ! [[ $1 =~ $re ]]; then
        echo "error: invalid date"
        exit 1
    fi
}

function check_params {
    if [[ $# -ne 1 ]]; then
        echo "Error: options must be 1" >&2
        show_legend
    fi

    re='^[1-3]$'
    if ! [[ $1 =~ $re ]]; then
        echo "Error: select mode from 1 to 3" >&2
        show_legend
    fi
}