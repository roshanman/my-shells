#!/bin/bash

IFS=$'\n'

function find_unused_with_pattern() {
    pattern=$1
    grep -r -m 1 --include=\*.m --include=\*.h --include=\*.mm $pattern .
}

function find_unused_with_pattern_in_swift_file() {
    pattern=$1
    # grep -r -m 1 --include=\*.swift  $pattern .
}

function find_unused_with_class_name() {
    class_name=$1
    pattern1="$class_name\\s\+\*"
    pattern2="\\[$class_name\\s"
    pattern3="$class_name\.class"
    pattern4="\"$class_name\""
    pattern5=":\\s$class_name"

    used=$(find_unused_with_pattern $pattern1)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern2)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern3)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern4)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern5)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern_in_swift_file $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    echo $class_name
}

total=$(grep -r -o --include=\*.m --include=\*.h  "@implementation\\s\w\+" . | awk '{print $2}' | sort | uniq | wc -l)
index=0
for class in $(grep -r -o --include=\*.m --include=\*.h  "@implementation\\s\w\+" . | awk '{print $2}' | sort | uniq); do
    printf "\r[%-50s]%d/%d" "$str" $index $total
    find_unused_with_class_name $class
    index=$((index+1))
done
