#!/bin/bash

count=$(find . -maxdepth 3 -name "*.podspec" | wc -l)

if [ $count -eq 0 ];then 
    echo -e "\033[031m没有找到Podspec文件\033[031m"
    exit 1
fi

if [ $count -eq 1 ];then 
    code $(find . -maxdepth 3 -name "*.podspec")
    exit 0
fi

PS3="请选择您要打开的文件:"

select i in $(find . -maxdepth 3 -name "*.podspec"); do
    code $i
    break
done