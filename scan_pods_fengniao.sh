#!/bin/bash

for i in $(find Pods -name "*" -maxdepth 1 -type d | grep -v "xcodeproj" | tail -n +2);do
    echo $i
    ( cd "$i" && fengniao < /Users/zhangxiuming/midong/t.txt)
    echo "==================="
done