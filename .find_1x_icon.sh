#!/bin/bash

IFS=$'\n'

for imageset in $(find . -name "*.imageset" -type d); do
    scale1_png_file_name=$(cat $imageset/Contents.json | jq ".images[0].filename" | sed 's/"//g')

    if [[ $scale1_png_file_name != 'null' ]]; then
        echo $imageset
    fi
done
