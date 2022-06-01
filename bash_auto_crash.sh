#!/bin/bash

IFS=$'\n'

dir=$1

if [[ -z $dir ]]; then
    echo "请提供目录"
    exit -1
fi

for file in $(find "$dir" -maxdepth 1 -name "*.crash" -type f);do
    sh ~/.auto_crash "$file"
done

for file in $(find "$dir" -maxdepth 1 -name "*.ips" -type f);do
    sh ~/.auto_crash "$file"
done