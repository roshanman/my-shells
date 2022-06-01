#!/bin/bash

IFS=$'\n'

for xib in $(find . -name "*.xib" | awk -F"/" '{print $NF}' | awk -F"." '{print $1}');do
    used=$(grep --include=\*.{h,m,swift,cpp} -r -m 1 "\"$xib\"" .)
    if [[ -z $used ]];then
        echo $xib".xib"
    fi
done