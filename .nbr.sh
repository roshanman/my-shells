#!/bin/bash

if [[ $# < 1 ]];then
    echo "需要提供分支名称"
    exit -1
fi

depth=$2

if [ -z $depth ];then
	depth=3
fi

git remote set-branches origin $1
git fetch --depth $depth origin $1
