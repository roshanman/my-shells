#!/bin/bash

IFS=$'\n'

for method in $(grep -r -h -o --include=\*.h "^[+-]\s\?([0-9a-zA-Z *]\+)\w\+;" | awk -F")" '{print $2}' | sed 's/;//g');do
    if [[ -z $(grep -r -m 1 --include=\*.h --include=\*.m "\s$method]") ]];then
        echo $method
    fi
done