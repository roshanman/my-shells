#!/bin/bash

IFS=$'\n'

if [ $# -lt 1 ]; then
    echo -e "\033[31m需要提供MiFit.xcodeproj目录\033[0m"
    exit 1
fi

project_pbxproj_path=$1"/project.pbxproj"

echo -e "\033[30m以下文件被Xcode工程引用但是本地文件已经被删除\033[0m"

~/.pbxproj $project_pbxproj_path --fileRef > .xcode_file_refs

for i in $(cat .xcode_file_refs);do
    if [[ $i == *.cpp ]] || [[ $i == *.m ]] || [[ $i == *.swift ]] || [[ $i == *.mm ]] || [[ $i == *.c ]] || [[ $i == *.h ]] || [[ $i == *.xib ]] || [[ $i == *.storyboard ]] || [[ $i == *.cpp ]]; then

        if ! [[ -f "$i" ]]; then
            echo -e "\033[31m    $i\033[0m" 
        fi
    fi
done

echo -e "\033[30m以下文件没有被引入到工程中,可能需要删除或者添加到工程中\033[0m"


for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.swift");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done

for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.m");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done

for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.mm");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done

for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.cpp");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done


for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.xib");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done


for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.storyboard");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done

for i in $(find . \( -path ./MiFitTests -o -path ./Pods -o -path ./.git -o -path ./Project -o -path ./MiFitUITests -o -path ./Docs -o -path ./fastlane -o -path ./Carthage \) -prune -o -type f -name "*.h");do

    f=$(echo ${i:2})

    matched=$( cat .xcode_file_refs | grep "$f"  )

    if [[ -z $matched ]]; then
        echo -e "\033[33m    $f\033[0m" 
    fi
done

rm .xcode_file_refs

echo -e "\033[30m以下文件被Xcode重复引用\033[0m"

~/.pbxproj $project_pbxproj_path --showDumplicateFile