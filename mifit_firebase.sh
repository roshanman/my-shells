#!/bin/bash

result=$(curl 'https://open.zepp.top/archive/api/log/notes?num=1&type=xiaomi&trigger=&versionCode=&versionName=&versionNumber=&status=1&env=&build_action=&client=iOS')


version_name=$(echo $result | jq  ".detail[0].versionName" | sed 's/"//g')
version_code=$(echo $result | jq  ".detail[0].version_number" | sed 's/"//g')

if [[ $version_name == "null" ]];then
    echo "未获取到最新版本信息"
else
   open "https://console.firebase.google.com/u/0/project/wsguyue/crashlytics/app/ios:HM.wristband/issues?state=open&time=last-ninety-days&versions=$version_name%20($version_code)&state=open&tag=all"
fi
