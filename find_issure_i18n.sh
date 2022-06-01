#!/bin/bash

IFS=$'\n'

search_path="$1"

if [ -z "$search_path" ];then
    search_path="."
fi

function is_key_exists() {
    key="$1"
    zh_cn_resource_path="$2"

    for f in $(find "$zh_cn_resource_path" -name "*.strings*"); do
        if [[ -n $(cat "$f" | grep "\"$key\"") ]] || [[ -n $(cat "$f" | grep "<key>$key</key>") ]]; then
            echo "1"
            return 0
        fi
    done

    echo "0"
}

function get_all_keys_in_oc_code() {
    oc_pattern="$1"
    grep -r -o --include='*.h' --include='*.m' "$oc_pattern(@\"[^\",)]*\"]*" "$search_path" | grep -o "\".*\"" | grep -o "\w\+"
}

function enum_issue_i18n_key_in_objc_code() {
    oc_pattern="$1"
    zh_cn_resource_path="$2"

    for i in $(get_all_keys_in_oc_code "$oc_pattern"); do
        if [ "$(is_key_exists "$i" "$zh_cn_resource_path")" -ne 1 ]; then
            echo $oc_pattern"(@\"$i\""
        fi
    done
}

function get_all_keys_in_swift_code() {
    swift_pattern="$1"
    grep -r -o  --include='*.swift' "$swift_pattern.string(\"[^\"]*\"" "$search_path" | grep -o "\".*\"" | grep -o "\w\+"
}

function enum_issue_i18n_key_in_swift_code() {
    swift_pattern="$1"
    zh_cn_resource_path="$2"

    for i in $(get_all_keys_in_swift_code "$swift_pattern"); do
        if [ "$(is_key_exists "$i" "$zh_cn_resource_path")" -ne 1 ]; then
            echo $swift_pattern".string(\"$i\""
        fi
    done
}

rm -rf /tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "MiDongLocalizedString" "Mifit/Localizable/MiDongLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.miDong" "Mifit/Localizable/MiDongLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "PublicLocalizedString" "Mifit/Localizable/PublicLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Public" "Mifit/Localizable/PublicLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "HomeLocalizedString" "Mifit/Localizable/HomeLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Home" "Mifit/Localizable/HomeLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "SmartLocalizedString" "Mifit/Localizable/SmartPlayLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Smart" "Mifit/Localizable/SmartPlayLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "MineLocalizedString" "Mifit/Localizable/MineLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Mine" "Mifit/Localizable/MineLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "RunLocalizedString" "Mifit/Localizable/RunLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Sport" "Mifit/Localizable/RunLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "HuamiLocalizedString" "Mifit/Localizable/HuamiLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Huami" "Mifit/Localizable/HuamiLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "WeatherLocalizedString" "Mifit/Localizable/WeatherLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Weather" "Mifit/Localizable/WeatherLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "MiDongWatchLocalizedString" "Mifit/Localizable/MiDongWatchLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.miDongWatch" "Mifit/Localizable/MiDongWatchLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "WatchOSLocalizableString" "Mifit/Localizable/WatchOSLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.WatchOS" "Mifit/Localizable/WatchOSLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "DateLocalizedString" "Mifit/Localizable/DateFormatLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Date" "Mifit/Localizable/DateFormatLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "ThirdAuthLocalizableString" "Mifit/Localizable/HMThirdAuthLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.ThirdAuth" "Mifit/Localizable/HMThirdAuthLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "LabLocalizableString" "Mifit/Localizable/LabLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.Lab" "Mifit/Localizable/LabLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

enum_issue_i18n_key_in_objc_code "StarrySkyLocalizableString" "Mifit/Localizable/StarrySkyLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result
enum_issue_i18n_key_in_swift_code "Localized.StarrySky" "Mifit/Localizable/StarrySkyLocalizable/zh-Hans.lproj/" >>/tmp/find_issue_i18n_key.result

for i in $(cat /tmp/find_issue_i18n_key.result | sort | uniq); do
    grep -r --color=auto --include='*.swift' --include='*.h' --include='*.m' "$i" "$search_path"
done
