#!/bin/bash

featuer_id=$1

if [ -z $featuer_id ];then
    echo "请输入Feature ID"
    exit 1
fi

sed "s/ID/$featuer_id/g" ~/.git-commit-template-feat > /tmp/.git-commit-template-feat

git commit --template=/tmp/.git-commit-template-feat