#!/bin/bash

if [ -f "Podfile" ];then
    pod install
    exit 0
fi

podfile_count=$(find . -maxdepth 3 -name "Podfile" | wc -l)

if [ $podfile_count -eq 0 ];then 
    echo -e "\033[031m没有找到任何Podfile文件\033[031m"
    exit 1
fi

if [ $podfile_count -eq 1 ];then 
    pushd .
    dir=$(find . -maxdepth 3 -name "Podfile" | sed 's/Podfile//')
    cd $dir
    pod install
    popd
    exit 0
fi

echo -e "\033[031m存在多个Podfile请进入指定目前运行Pod install命令\033[031m"
