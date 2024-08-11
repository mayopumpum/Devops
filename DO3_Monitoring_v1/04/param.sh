#!/bin/bash

print_conf=0

function check_color {
    if [ "$1" \> 0 ] && [ "$1" \< 7 ]
    then
        return 0
    else
        return 1
    fi
}

function load_default {
    . ./default.conf
    check_color $column1_background
    check1=$?
    check_color $column1_font_color
    check2=$?
    check_color $column2_background
    check3=$?
    check_color $column2_font_color
    check4=$?
    if [ $check1 = 1 ] || [ $check2 = 1 ] || [ $check3 = 1 ] || [ $check4 = 1 ]
    then
        echo "All parameters must be digits from 0 to 6."
        exit 1
    else
        colors[0]=$column1_background
        colors[1]=$column1_font_color
        colors[2]=$column2_background
        colors[3]=$column2_font_color   
        print_conf=1
    fi
}

function load_params {
    . ./config.conf

    check_color $column1_background
    check1=$?
    check_color $column1_font_color
    check2=$?
    check_color $column2_background
    check3=$?
    check_color $column2_font_color
    check4=$?

    if [ $check1 = 0 ] && [ $check2 = 0 ] && [ $check3 = 0 ] && [ $check4 = 0 ]
    then
        colors[0]=$column1_background
        colors[1]=$column1_font_color
        colors[2]=$column2_background
        colors[3]=$column2_font_color
    else
        load_default $colors
    fi    
    #if [ $check1 = 1 ] || [ $check2 = 1 ] || [ $check3 = 1 ] || [ $check4 = 1 ] || [ ${#colors[*]} -ne 4 ]
    #then
    #    load_default
    #fi
}

function print_color {
    colors_name=("white" "red" "green" "blue" "purple" "black")
    echo "Column 1 background = ${colors[0]} (${colors_name[$1 - 1]})"
    echo "Column 1 font color = ${colors[1]} (${colors_name[$2 - 1]})"
    echo "Column 2 background = ${colors[2]} (${colors_name[$3 - 1]})"
    echo "Column 2 font color = ${colors[3]} (${colors_name[$4 - 1]})"
}

function print_color_default {
    colors_name1=("white" "red" "green" "blue" "purple" "black")
    echo "Column 1 background = default (${colors_name1[$1 - 1]})"
    echo "Column 1 font color = default (${colors_name1[$2 - 1]})"
    echo "Column 2 background = default (${colors_name1[$3 - 1]})"
    echo "Column 2 font color = default (${colors_name1[$4 - 1]})"
}

colors=(0 0 0 0)

load_params $colors