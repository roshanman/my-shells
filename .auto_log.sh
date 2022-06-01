#!/bin/bash

if [ $# -lt 1 ]; then
    echo -e "\033[31m需要提供日志文件或者日志目录\033[0m"
    exit 1
fi

if [ -f 'HMLog.sqlite' ];then
    rm -rf  HMLog.sqlite
fi

if [[ -f "$1" ]];then
    echo -e "\033[32m正在解析日志文件到数据库中\033...\033[0m"

    python3 ~/.auto_log.py $1
    open HMLog.sqlite
    exit 0
fi

if [[ -d "$1" ]];then

    for file in $(ls "$1");do
        if ! [[ -z $(echo $file | grep '^\d\d\d\d-\d\d-\d\d$') ]];then
            echo -e "\033[32m正在解析日志文件($file)到数据库中...\033[0m"

            python3 ~/.auto_log.py "$1""/""$file"
        fi
    done

    if [ -f  "$1/logan.mmap2" ];then
            echo -e "\033[32m正在解析日志文件(logan.mmap2)到数据库中...\033[0m"
	    python3 ~/.auto_log.py "$1/logan.mmap2"
    fi

    open HMLog.sqlite

    exit 0
fi

echo -e "\033[31m传入的参数有问题，请检查下[0m"
