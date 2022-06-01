#!/bin/bash

ref_id=$1

if [ -z $ref_id ];then
    echo "请输入Ref ID"
    exit 1
fi

sed "s/ID/$ref_id/g" ~/.git-commit-template-ref > /tmp/.git-commit-template-ref

git commit --template=/tmp/.git-commit-template-ref