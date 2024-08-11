#!/bin/bash

. ./func.sh

get_info
echo "Write info to file? Enter Y/N"
read answer
if [ $answer = "Y" ] || [ $answer = "y" ]
then
    filename=`date +'%d_%m_%y_%H_%M_%S.status'`
    echo "Write to file $filename"
    get_info > $filename
fi