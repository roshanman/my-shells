#!/bin/bash

IFS=$'\n'

function find_unused_with_pattern() {
    pattern=$1
    class_name=$2
    grep --include=\*.swift --exclude=$class_name.swift -r -m 1 $pattern .
}

function find_unused_with_pattern_in_objc_file() {
    pattern=$1
    grep --include=\*.{mm,m,h} -r -m 1 $pattern .
}

function find_unused_with_class_name() {
    class_name=$1
    pattern1="$class_name\." # obj.
    pattern2="\\[$class_name\\s" # [objc 
    pattern3="$class_name(" # obj(
    pattern4=": $class_name" # : obj 继承
    pattern5="\sas..$class_name" # as obj
    pattern6="$class_name!" # obj!
    pattern7="$class_name?" # obj?
    pattern8="\\[$class_name\\]" # obj?

    used=$(find_unused_with_pattern $pattern8 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern7 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern6 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern1 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern3 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern4 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern $pattern5 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    used=$(find_unused_with_pattern_in_objc_file $pattern2 $class_name)

    if ! [[ -z $used ]]; then
        return 0
    fi

    echo $class_name
}

for class in $(grep --include=\*.swift -r -o -m 1 "struct\\s\w\+" . | awk '{print $2}' | sort | uniq); do
    find_unused_with_class_name $class
done
