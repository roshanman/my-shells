#!/bin/bash

plist=$(find . -maxdepth 4 -name "MiDong-Info.plist")

if [ -z $plist ]; then
    echo -e "\033[33m没有找到MiDong-Info.plist文件\033[0m"
    exit 1
fi

if [ $# -eq 0 ];then 
    code=$(awk -f "/Users/zhangxiuming/.show_version_code.awk" "$plist")
    echo -e "\033[32m $code \033[0m"
else
    awk -f "/Users/zhangxiuming/.fix_version_code.awk" "$plist" > ".new_midong_info.plist"
    mv ".new_midong_info.plist" "$plist"
fi
