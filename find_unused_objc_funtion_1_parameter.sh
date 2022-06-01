#!/bin/bash

IFS=$'\n'

for method in $(grep -r -h -o --include=\*.h "^[+-]\s\?([0-9a-zA-Z *]\+)\w\+:([0-9a-zA-Z *]\+)\s\?\w\+;" | awk -F":" '{print $1}' | awk -F")" '{print $2}');do
    if [[ -z $(grep -r -m 1 --include=\*.h --include=\*.m "\s$method:[^:]\+]") ]];then
        echo $method
    fi
done