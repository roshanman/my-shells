#!/bin/bash

result=$(curl --location --request GET 'https://open.zepp.top/archive/api/log/notes?num=1&type=midong&trigger=&versionCode=&versionName=&versionNumber=&status=1&env=&app_backup=zepp&build_action=&client=iOS')

offset=0

while true; do
    version_name=$(echo $result | jq  ".detail[$offset].versionName")
    version_number=$(echo $result | jq  ".detail[$offset].version_number")
    version_code=$(echo $result | jq  ".detail[$offset].versionCode")
    if [[ $version_name == "null" ]];then
        break;
    fi
    echo $(echo "$version_name : $version_number : $version_code" | sed 's/"//g')
    offset=$((offset+1))
done 

