#!/bin/bash

# Localized\..*?.string\(".*?","
# cat /Users/zhangxiuming/health_data/HomeUI/BreathQualityCard/BreathQualityCardView.swift | tr -d "\n"  | tr -d " "> t.txt
# cat t.txt | awk -F"string" '{print $2}' | sed 's/","//g' | sed 's/("//g' | uniq
 
for i in $(find . -name "*.swift"); do
    pcregrep -Mo 'Localized.*[\n]?.*"' "$i"
done
