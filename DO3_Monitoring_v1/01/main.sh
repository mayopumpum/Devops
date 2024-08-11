#!/bin/bash

if [ -n "$1" ]
then
    if [[ $1 =~ (^[+-]?[0-9]+([\,\.][0-9]+)?$) ]]
    then
        echo "Error input"
        exit 1
    else
        echo $1
    fi
else
    echo "Error: No arguments"
fi