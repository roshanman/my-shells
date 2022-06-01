#!/bin/bash

echo "> 开始检查BuildConfig.plist和FeatureSwitch+Methods.h的对应关系, 二者必须一一对应否则不能开始编译"

for key in $(cat MiFit/SupportingFiles/BuildConfig.plist | grep ".*<key>.*" | sed 's/<key>enable<\/key>//' | sed 's/<key>description<\/key>//' | sed 's/<key>//' | sed 's/<\/key>//' | awk '{print $1}' | sed '/^$/d' | sed 's/_//g'); do
    fined=$(cat MiFit/SupportingFiles/FeatureSwitch+Methods.h | grep -i -m 1 $key)

    if [[ -z $fined ]]; then
        echo "> key: $key 存在plist文件中但是FeatureSwitch+Methods.h没有配置, 可能已过期"
    fi
done

allKeys=$(cat MiFit/SupportingFiles/BuildConfig.plist | grep ".*<key>.*" | sed 's/<key>enable<\/key>//' | sed 's/<key>description<\/key>//' | sed 's/<key>//' | sed 's/<\/key>//' | awk '{print $1}' | sed '/^$/d' | sed 's/_//g')
for method in $(cat MiFit/SupportingFiles/FeatureSwitch+Methods.h | grep "(BOOL)" | sed 's/;//g' | awk -F')' '{print $2}'); do
    if ! grep -i -q $method <<<$allKeys; then
        echo "$method 方法在FeatureSwitch+Methods.h配置，但是BuildConfig.plist没有配置❌❌❌"
        exit -1
    fi
done
