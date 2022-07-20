#!/bin/bash

# 脚本作用
# 根据如下格式的文件将对应的翻译资源从国际化资源文件中提取出来重新生成一个国际化资源文件
# //   PublicLocalizedString "public_cancel" 226
# //   PublicLocalizedString "public_confirm" 119
# //   PublicLocalizedString "public_Iknow" 116
# 生成后的文件格式为.strings
# "public_cancel" = "xxx";
# "public_confirm" = "xxx";
# "public_Iknow" = "xxx";

IFS=$'\n'
file=$1

i18n_res_path="/Users/zhangxiuming/midong/MiFit/Localizable"

if [ -z $file ]; then
    echo "请输入文件路劲"
    exit -1
fi

function get_folder_name() {
    case "$1" in
    "DateLocalizedString")
        echo "DateFormatLocalizable"
        ;;
    "HomeLocalizedString")
        echo "HomeLocalizable"
        ;;
    "HuamiLocalizedString")
        echo "HuamiLocalizable"
        ;;
    "MineLocalizedString")
        echo "MineLocalizable"
        ;;
    "PublicLocalizedString")
        echo "PublicLocalizable"
        ;;
    "SimplifiedChineseLocalizedString")
        echo "SimplifiedChineseLocalizable"
        ;;
    "SmartLocalizedString")
        echo "SmartPlayLocalizable"
        ;;
    "RunLocalizedString")
        echo "RunLocalizable"
        ;;
    "StarrySkyLocalizableString")
        echo "StarrySkyLocalizable"
        ;;
    "ThirdAuthLocalizedString")
        echo "HMThirdAuthLocalizable"
        ;;
    "ThirdAuthLocalizableString")
        echo "HMThirdAuthLocalizable"
        ;;
    "WatchOSLocalizableString")
        echo "WatchOSLocalizable"
        ;;
    "MiDongLocalizedString")
        echo "MiDongLocalizable"
        ;;
    "MiDongWatchLocalizedString")
        echo "MIDongWatchLocalizable"
        ;;
    *)
        echo "缺失folder路径规则: $folder"
        exit -2
        ;;
    esac
}

function get_strings_file_path() {
    path=$1
    find $path -name "*strings"
}

function get_value_from_folder() {
    folder="$1"
    key="$2"
    language="$3"

    folder_name=$(get_folder_name $folder)
    folder_abs_path="$i18n_res_path/$folder_name/$language.lproj"
    strings_file_abs_path=$(get_strings_file_path $folder_abs_path)

    swift /Users/zhangxiuming/my-shells/i18n_gen.swift "$strings_file_abs_path" "$key"
}

echo "/* 
  General.strings
  Pods

  Created by Razi on 2022/7/15.
*/
"

for i in $(cat $file | grep "^//" | awk '{print $2,$3}'); do
    folder=$(echo $i | awk '{print $1}')
    key=$(echo $i | awk '{print $2}')

    en_value=$(get_value_from_folder $folder $key "en")
    zh_hans_value=$(get_value_from_folder $folder $key "zh-Hans")

    if [[ "$en_value" = "\"\"" ]] || [[ "$zh_hans_value" = "\"\"" ]];then
        echo "无法读取 $folder $key" >&2
        continue
    fi

    echo "/// $ky $zh_hans_value"
    echo "$key"" = ""$en_value"";"
done
