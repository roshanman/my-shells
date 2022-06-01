#!/bin/bash

IFS=$'\n'

for h in $( find . -name "*.h" ); do
    file_name=$(echo $h | awk -F"/" '{print $NF}' | awk -F"." '{print $1}')
    fined=$(grep --include=\*.{mm,m,h} --exclude=$file_name".m" -r -m 1 "#import \"$file_name".h"\"" .)
    if [[ -z $fined ]];then 
        echo $h
    fi
done
