#!/bin/bash

for p in $(grep -r -o --exclude-dir="./App/MiDong/UI/Device/FM/XimalayaSDK/include" '^@property\s\?(.*)\s\?\w\+[^(]*;' . | awk -F" " '{print $NF}' | awk -F">" '{print $NF}' | awk -F"*" '{print $NF}' | sed 's/;//g' | sort | uniq); do
    if [[ -z $(grep -r -m 1 --include=\*.h --include=\*.m "\.$p") ]]; then
        echo "$p"
    fi
done
