#!/bin/bash

IFS=$'\n'

sum=0

for i in $(find MiFit/Localizable -name "*Hant.lproj*" -type d);do
    count=$(grep -r "^\"" $i | wc -l )
    sum=$(($sum+$count))
done

for i in $(find MiFit/Localizable -name "*Hant.lproj*" -type d);do
    count=$(grep -r "NSStringLocalizedFormatKey" $i | wc -l )
    sum=$(($sum+$count))
done

echo "total count key: $sum"