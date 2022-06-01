#!/bin/bash

# IFS=$'\n'

for lan in $(find . -name "*.strings" | grep "zh-Hans.lproj.*strings$"); do

    echo -e "\033[32m"$lan"\033[0m"

    for key in $(cat $lan | grep "^\"" | awk -F"=" '{print $1}'); do

        fined=$(grep --include=\*.{m,mm,c,h,swift} --exclude=\*.{git} -r -m 1 "$key" .)

        if [[ -z $fined ]]; then
            echo "    "$key
        fi

    done

done
