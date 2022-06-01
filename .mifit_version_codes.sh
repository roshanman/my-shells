#!/bin/bash

result=$(curl 'https://api-archive.athuami.com/api/log/notes?num=1&type=xiaomi&trigger=&versionCode=&versionName=&versionNumber=&status=1&env=&build_action=&client=iOS')

offset=0

while true; do
    version_name=$(echo $result | jq  ".detail[$offset].versionName")
    version_code=$(echo $result | jq  ".detail[$offset].version_number")
    if [[ $version_name == "null" ]];then
        break;
    fi
    echo $(echo "$version_name: $version_code" | sed 's/"//g')
    offset=$((offset+1))
done

