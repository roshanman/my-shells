#!/bin/bash

IFS=$'\n'

for sb in $(find . -name "*.storyboard" | awk -F"/" '{print $NF}' | awk -F"." '{print $1}');do
    used=$(grep --include=\*.{h,m,swift,cpp} -r -m 1 "\"$sb\"" .)
    if [[ -z $used ]];then
        echo $sb".storyboard"
    fi
done