#!/bin/bash

if ! which jq >/dev/null; then
  echo -e "\033[31m请先安装json解析工具\033[33mbrew install jq\033[0m"
  exit 1
fi

issue_dir=""
scale1_file=""

function fix() {
  local dir=$1
  local asset_name=$(echo $dir | awk -F '/' '{print $NF}' | sed 's/.imageset//')

  local scale1_png_file_name=$(cat $dir/Contents.json | jq ".images[0].filename" | sed 's/"//g')
  local scale2_png_file_name=$(cat $dir/Contents.json | jq ".images[1].filename" | sed 's/"//g')
  local scale3_png_file_name=$(cat $dir/Contents.json | jq ".images[2].filename" | sed 's/"//g')

  if [[ $scale1_png_file_name != "null" ]]; then
    scale1_file="$scale1_file$dir\n"
  fi

  if [[ $scale1_png_file_name != "null" ]] && ! [[ -f "$dir/$scale1_png_file_name" ]]; then
    issue_dir="$issue_dir$dir\n"
    return 0
  elif [[ $scale2_png_file_name != "null" ]] && ! [[ -f "$dir/$scale2_png_file_name" ]]; then
    issue_dir="$issue_dir$dir\n"
    return 0
  elif [[ $scale3_png_file_name != "null" ]] && ! [[ -f "$dir/$scale3_png_file_name" ]]; then
    issue_dir="$issue_dir$dir\n"
    return 0
  fi 2>/dev/null

  local need_rewrite_content_json=0

  if [[ $scale1_png_file_name != "null" ]]; then
    if ! [[ -f "$dir/$asset_name.png" ]]; then
      need_rewrite_content_json=1
      git mv "$dir/$scale1_png_file_name" "$dir/$asset_name.png"
    fi 2>/dev/null
  fi

  if [[ $scale2_png_file_name != "null" ]]; then
    if ! [[ -f "$dir/$asset_name@2x.png" ]]; then
      need_rewrite_content_json=1
      git mv "$dir/$scale2_png_file_name" "$dir/$asset_name@2x.png"
    fi 2>/dev/null
  fi

  if [[ $scale3_png_file_name != "null" ]]; then
    if ! [[ -f "$dir/$asset_name@3x.png" ]]; then
      need_rewrite_content_json=1
      git mv "$dir/$scale3_png_file_name" "$dir/$asset_name@3x.png"
    fi 2>/dev/null
  fi

  if [[ $need_rewrite_content_json -eq 0 ]]; then
    return 0
  fi

  scale1_content_json='    {\n      "idiom" : "universal",\n      "filename" : "'$asset_name@.png'",\n      "scale" : "2x"\n    },'

  scale2_content_json='    {\n      "idiom" : "universal",\n      "filename" : "'$asset_name@2x.png'",\n      "scale" : "2x"\n    },'

  scale3_content_json='    {\n      "idiom" : "universal",\n      "filename" : "'$asset_name@3x.png'",\n      "scale" : "3x"\n    }'

  if ! [[ -f "$dir/$asset_name@1x.png" ]]; then
    scale1_content_json='    {\n      "idiom" : "universal",\n      "scale" : "1x"\n    },'
  fi

  if ! [[ -f "$dir/$asset_name@2x.png" ]]; then
    scale2_content_json='    {\n      "idiom" : "universal",\n      "scale" : "2x"\n    },'
  fi

  if ! [[ -f "$dir/$asset_name@3x.png" ]]; then
    scale3_content_json='    {\n      "idiom" : "universal",\n      "scale" : "3x"\n    }'
  fi

  contents='{\n  "images" : [\n'$scale1_content_json"\n"$scale2_content_json"\n"$scale3_content_json"\n"'  ],\n  "info" : {\n    "version" : 1,\n    "author" : "xcode"\n  }'

  echo "$contents" >"$dir/Contents.json"
  printf "}" >>"$dir/Contents.json"
}

progressbar() {
  local current=$1
  local total=$2
  local now=$((current * 100 / total))
  local last=$(((current - 1) * 100 / total))
  [[ $((last % 2)) -eq 1 ]] && let last++
  local str=$(for i in $(seq 1 $((last / 2))); do printf '#'; done)

  printf "\r[%-50s]%d/%d" "$str" $current $total
}

IFS=$'\n'

total_count=$(find . -name "*.imageset" -type d | wc -l)
current_index=1
for asset in $(find . -name "*.imageset" -type d); do
  progressbar $current_index $total_count
  current_index=$(($current_index + 1))
  fix $asset
done

echo ""
if ! [[ -z $issue_dir ]]; then
  echo "以下资源存在问题:"
  echo -e "$issue_dir"
fi

echo -e "\033[32m\n处理完毕请查看git状态\033[0m"

if ! [[ -z $scale1_file ]];then
  echo "以下目录存在1x图片"
  echo $scale1_file
fi