#!/bin/bash

result=$(curl --location --request GET 'https://open.zepp.top/archive/api/log/notes?num=1&type=midong&trigger=&versionCode=&versionName=&versionNumber=&status=1&env=&app_backup=zepp&build_action=&client=iOS')


version_name=$(echo $result | jq  ".detail[0].versionName" | sed 's/"//g')
version_code=$(echo $result | jq  ".detail[0].version_number" | sed 's/"//g')

echo "$version_name"

if [[ $version_name == "null" ]];then
    echo "未获取到最新版本信息"
else
   open "https://console.firebase.google.com/project/huamiamazfit/crashlytics/app/ios:com.huami.watch/issues?hl=zh-cn&time=last-ninety-days&versions=$version_name%20($version_code)&state=open&tag=all"
fi