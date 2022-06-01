#!/bin/bash

IFS=$'\n'

# ➜  midong git:(midong/6.7.0) ✗ grep -E -r --include="*.h" --include="*.m" --include="*.swift" 'MineLocalizedString\(@"bind_fail"|Localized.Mine.string\("bind_fail"' | awk -F":" '{print $1}' | awk -F"/" '{print $2"/"$3}' | sort | uniq
# MiFit/App
# Pods/HMAccountServices

function enum_i18n_res_in_swift_code() {
    grep -r -E -o -h --include="*.swift" 'Localized.\w+.string\("[^"]+"' | sed 's/Localized.//g' | sort | uniq | sed 's|.string(| |g' |
        sed 's/Date /DateLocalizedString /g' |
        sed 's/Home /HomeLocalizedString /g' |
        sed 's/Huami /HuamiLocalizedString /g' |
        sed 's/Mine /MineLocalizedString /g' |
        sed 's/Public /PublicLocalizedString /g' |
        sed 's/Simplified /SimplifiedChineseLocalizedString /g' |
        sed 's/Smart /SmartLocalizedString /g' |
        sed 's/Sport /RunLocalizedString /g' |
        sed 's/StarrySky /StarrySkyLocalizableString /g' |
        sed 's/ThirdAuth /ThirdAuthLocalizableString /g' |
        sed 's/WatchOS /WatchOSLocalizableString /g' |
        sed 's/miDong /MiDongLocalizedString /g' |
        sed 's/miDongWatch /MiDongWatchLocalizedString /g'
}

function enum_i18n_res_in_objc_code() {
    grep -r -E -h -o --include="*.h" --include="*.m" '\w+(LocalizedString|LocalizableString)\(@"[^"]+"' | sort | uniq | sed 's/(@/ /g'
}

function merge_swift_oc_i18n_res() {
    (
        enum_i18n_res_in_swift_code &
        enum_i18n_res_in_objc_code
    ) | sort | uniq
}

function get_regex_with_i18n_folder_and_key() {
    folder=$(echo $1 | awk '{print $1}')
    key=$(echo $1 | awk '{print $2}')
    oc_pattern="$folder\(@$key"
    swift_pattern="$(get_swift_regx_patter_with_folder $folder $key)"
    echo "$swift_pattern|$oc_pattern"
}

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

function count_every_i18n_res() {
    for i18n in $(merge_swift_oc_i18n_res); do
        echo "\n>>>>>>> ${i18n}"
        regx=$(get_regex_with_i18n_folder_and_key "$i18n")
        # grep -E -r --include="*.h" --include="*.m" --include="*.swift" 'MineLocalizedString\(@"bind_fail"|Localized.Mine.string\("bind_fail"' | awk -F":" '{print $1}' | awk -F"/" '{print $2"/"$3}' | sort | uniq
        grep -E -r --include="*.h" --include="*.m" --include="*.swift" "$regx" | awk -F":" '{print $1}' | awk -F"/" '{print $2"/"$3}' | sort | uniq
    done
}

count_every_i18n_res