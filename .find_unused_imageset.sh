#!/bin/bash

IFS=$'\n'

suffix=$1

if [ -z $suffix ]; then
  echo "请提供需要查下的文件后缀"
  exit 0
fi

suffix_type="f"

if [[ $suffix == "imageset" ]]; then
  suffix_type="d"
fi

total_count=$(find . -path ./Pods -prune -o -name "*.$suffix" -type $suffix_type | wc -l | sed 's/ //g')
current_index=0

finished=""
ceol=$(tput el)

imagesetused() {
  local current=$2
  local total=$3

  local imageset_path=$1
  local asset_name=$(echo $imageset_path | awk -F '/' '{print $NF}' | sed "s/.$suffix//")

  finded=$(grep --exclude-dir=Pods --exclude-dir=.git --include=\*.{cpp,h,m,mm,c,swift,xib,storyboard} -r -m 1 "\"$asset_name\"" .)

  if [[ -z $finished ]]; then

    if [[ -z $finded ]]; then
      finded=$(grep --exclude-dir=Pods --exclude-dir=.git --include=\*.{cpp,h,m,mm,c,swift,xib,storyboard} -r -m 1 "\"$asset_name.$suffix\"" .)
      if [[ -z $finded ]]; then
        printf "\r${ceol} %4d/%d %s \n" "$current_index" $total_count "$imageset_path"
      else
        printf "\r${ceol} %4d/%d %s " "$current_index" $total_count "$imageset_path"
      fi
    else
      printf "\r${ceol} %4d/%d %s " "$current_index" $total_count "$imageset_path"
    fi

  fi
}

for asset in $(find . -path ./Pods -prune -o -name "*.$suffix" -type $suffix_type | sort); do
  current_index=$(($current_index + 1))

  if [ $current_index = $total_count ]; then
    finished="yes"
  fi

  imagesetused $asset $current_index $total_count
done
