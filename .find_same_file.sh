#!/bin/bash

IFS=$'\n'

suffix=$1

function error_echo() {
    echo -e "\033[32m$1\033[0m"
}

if [ -z $suffix ]; then
    error_echo "需要提供查询文件的后缀(txt,swift,json,m,h,png,jpg,webp,css,html,js...)"
    exit 0
fi

temp_folder="/tmp/find_same_file"
rm -rf $temp_folder
mkdir $temp_folder

for i in $(find . -name "*.$suffix"); do
    md5_value=$(md5 $i | awk -F"=" '{print $NF}' | sed 's/ //g')
    echo $i >>"$temp_folder/$md5_value.txt"
done

for i in $(find "$temp_folder" -name "*.txt"); do
    lines=$(cat $i | wc -l)
    if [[ $lines -gt 1 ]]; then
        first_file=$(cat $i | head -1)
        file_size=$(ls -lh $first_file | awk '{ print $5 }')
        echo "\n================================$file_size================================"
        cat $i
    fi
done
