#!/bin/bash

IFS=$'\n'

echo "以下输出内容说明图片名称重复:"

find . -name "*.imageset" | awk -F'/' '{print $NF}' | uniq -d
exit 0

find MiFit -name "*.webp" | awk -F'/' '{print $NF}' | uniq -d

find MiFit -name "*.jpg" | awk -F'/' '{print $NF}' | uniq -d

find MiFit -name "*.png" | awk -F'/' '{print $NF}' | uniq -d

echo  -e "\n查找1x图片:"
for json in $(find MiFit -name "Contents.json");do
    filename1x=$( cat $json | jq ".images[0].filename" )
    if ! [[ $filename1x == "null" ]];then
        echo $json
    fi
done

echo  -e "\n以下输出内容说明图片size相同可能是相同的图片:"

for size in $(for i in $(find MiFit -name "*.png");do
    size=$(ls -la $i | awk -F' ' '{print $5}')
    echo $size
done | uniq -d);do

    echo "=================================="

    for png in $(find MiFit -name "*.png");do
        sz=$(ls -la $png | awk -F' ' '{print $5}')

        if [[ $sz -eq $size ]]; then
            echo $png
        fi

    done

done

for size in $(for i in $(find MiFit -name "*.jpg");do
    size=$(ls -la $i | awk -F' ' '{print $5}')
    echo $size
done | uniq -d);do

    echo "=================================="

    for jpg in $(find MiFit -name "*.jpg");do
        sz=$(ls -la $jpg | awk -F' ' '{print $5}')

        if [[ $sz -eq $size ]]; then
            echo $jpg
        fi

    done

done