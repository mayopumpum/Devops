#!/bin/bash

. ./param.sh

. ./func.sh

get_info ${colors[*]}
echo

if [[ $print_conf -eq 0 ]]
then
    print_color ${colors[*]}
else
    print_color_default ${colors[*]}
fi

exit 0 