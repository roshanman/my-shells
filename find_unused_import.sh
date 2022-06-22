#!/bin/bash

IFS=$'\n'

for h in $(find . -name "*.h" | grep -v "MiFit-Bridging-Header.h"); do
    classes=$(cat "$h" | grep -o "@interface \\w\+" | awk '{print $2}' | sort | uniq)
    file_name_with_extension=$(echo "$h" | awk -F"/" '{print $NF}')
    file_name=$(echo "$file_name_with_extension" | awk -F"." '{print $1}')

    for import in $(grep -r --include=\*.h --include=\*.m --exclude="$file_name.m" --exclude=MiFit-Bridging-Header.h --exclude="$file_name.h" "\"$file_name_with_extension\"" . | awk -F":" '{print $1}'); do

        real_used=0
        for class in $(echo $classes | awk '{for (i=1;i<=NF;i++) {print $i}}'); do

            # echo  "$import > $file_name_with_extension > $class "

            # echo "1$(cat $import | grep -v "$file_name_with_extension" | grep "\\W$class\\W")2"

            if [[ -n $(cat "$import" | grep -v "$file_name_with_extension" | grep "\\W$class\\W") ]]; then
                real_used=1
                break
            fi

            if [[ -n $(cat "$import" | grep -v "$file_name_with_extension" | grep "\\W$class$") ]]; then
                real_used=1
                break
            fi
        done

        if [ $real_used -eq 0 ]; then
            echo "$file_name_with_extension | $import"
        fi
    done
done
