#!/bin/bash

set -e

name=$1
version=$2

function errorEcho() {
    echo -e "\033[31m$1\033[0m"
}

function infoEcho() {
    echo -e "\033[33m$1\033[0m"
}

function successEcho() {
    echo -e "\033[32m$1\033[0m"
}

if [[ -z $name ]] || [[ -z $version ]]; then
    errorEcho "参数不完整，命令格式如下$ gat sleep 1.1.0 (请注意第一个参数的大小写)"
    exit -1
fi

tag="$1/$2"

# check tag 是否已被占用
if git rev-parse "$tag" >/dev/null 2>&1; then
    errorEcho "tag $tag 已经存在"
    exit -1
fi

function toFirstLetterUpper() {
    str=$1
    firstLetter=$(echo ${str:0:1} | awk '{print toupper($0)}')
    otherLetter=${str:1}
    result=$firstLetter$otherLetter
    echo $result
}

function toFirstSecondLetterUpper() {
    str=$1
    firstLetter=$(echo ${str:0:2} | awk '{print toupper($0)}')
    otherLetter=${str:2}
    result=$firstLetter$otherLetter
    echo $result
}

if [[ $(echo ${name:0:1}) == i ]]; then
    # 更新接口版本
    podspec="$(toFirstSecondLetterUpper $name)"".podspec"
else
    # 更新业务仓库版本
    podspec="HD""$(toFirstLetterUpper $name)"".podspec"
fi

if ! [ -f $podspec ]; then
    errorEcho "文件 $podspec 不存在"
    exit -1
fi

commit_message="build |> update $podspec $version"

infoEcho "podspec: $podspec"
infoEcho "tag: $tag"

sed "s/\(.*s.version.*=\)\(.*\)/\1 \'$version\'/" $podspec >.temp.txt

cat .temp.txt >$podspec
rm .temp.txt

git add .
git commit -m "$commit_message"
git tag $tag

infoEcho "commit message: $commit_message"

successEcho "处理完成，请先将提交push到Gerrit合并进仓库以后再将tag push到gerrit"
