#!/bin/bash

fix_id=$1

if [ -z $fix_id ];then
    echo "请输入BUG ID"
    exit 1
fi

sed "s/ID/$fix_id/g" ~/.git-commit-template-fix > /tmp/.git-commit-template-fix

git commit --template=/tmp/.git-commit-template-fix

