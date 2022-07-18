#!/bin/bash

IFS=$'\n'

file=$1


function get_swift_regx_patter_with_folder() {
    case "$1" in
    "DateLocalizedString")
        echo "Localized.Date.string\($2"
        ;;
    "HomeLocalizedString")
        echo "Localized.Home.string\($2"
        ;;
    "HuamiLocalizedString")
        echo "Localized.Huami.string\($2"
        ;;
    "MineLocalizedString")
        echo "Localized.Mine.string\($2"
        ;;
    "PublicLocalizedString")
        echo "Localized.Public.string\($2"
        ;;
    "SimplifiedChineseLocalizedString")
        echo "Localized.Simplified.string\($2"
        ;;
    "SmartLocalizedString")
        echo "Localized.Smart.string\($2"
        ;;
    "RunLocalizedString")
        echo "Localized.Sport.string\($2"
        ;;
    "StarrySkyLocalizableString")
        echo "Localized.StarrySky.string\($2"
        ;;
    "ThirdAuthLocalizedString")
        echo "Localized.ThirdAuth.string\($2"
        ;;
    "ThirdAuthLocalizableString")
        echo "Localized.ThirdAuth.string\($2"
        ;;
    "WatchOSLocalizableString")
        echo "Localized.WatchOS.string\($2"
        ;;
    "MiDongLocalizedString")
        echo "Localized.miDong.string\($2"
        ;;
    "MiDongWatchLocalizedString")
        echo "Localized.miDongWatch.string\($2"
        ;;
    esac
}

function get_swift_regex_with_i18n_folder_and_key() {
    folder=$(echo $1 | awk '{print $1}')
    key=$(echo $1 | awk -F"\"" '{OFS="\"";$1=""; print $0}')
    swift_pattern="$(get_swift_regx_patter_with_folder $folder $key)"
    echo "$swift_pattern"
}

function get_oc_regex_with_i18n_foler_and_key() {
    folder=$(echo $1 | awk '{print $1}')
    key=$(echo $1 | awk -F"\"" '{OFS="\"";$1=""; print $0}')

    oc_pattern="$folder\(@$key"
    echo "$oc_pattern"
}

function count_every_i18n_res() {
    for i18n in $(cat $file); do

        swift_regx=$(get_swift_regex_with_i18n_folder_and_key "$i18n")
        oc_regx=$(get_oc_regex_with_i18n_foler_and_key "$i18n")

echo "$oc_regx"


grep -E -r -o --include="*.h" --include="*.m" $oc_regx
        # swift=$(grep -E -r -o --include="*.swift" "$swift_regx")


        # count_swift=$(echo "$swift" | grep "\./" | wc -l)
        # count_objc=$(echo "$objc" | grep "\./" | wc -l)
        # count=$(($count_swift + $count_objc))

        # echo "\n## $index ${i18n}""\n$objc""\n$swift"

    done
}

count_every_i18n_res