#!/bin/bash

IFS=$'\n'

match_reg='"\([^,]*\)",.[^)]*"'

trim() {
    str=$1
    echo "${str}" | grep -o "[^ ]\+\( \+[^ ]\+\)*"
}

function forSwift() {
    for i in $(find . -name "*.swift"); do

        sed 's|Localized.Public.string("\([^,]*\)",.[^)]*")|i18n.public.\1|g' $i |
            sed 's|Localized.Home.string("\([^,]*\)",.[^)]*")|i18n.home.\1|g' |
            sed 's|Localized.Smart.string("\([^,]*\)",.[^)]*")|i18n.smartPlay.\1|g' |
            sed 's|Localized.Mine.string("\([^,]*\)",.[^)]*")|i18n.mine.\1|g' |
            sed 's|Localized.Sport.string("\([^,]*\)",.[^)]*")|i18n.run.\1|g' |
            sed 's|Localized.miDong.string("\([^,]*\)",.[^)]*")|i18n.miDong.\1|g' |
            sed 's|Localized.miDongWatch.string("\([^,]*\)",.[^)]*")|i18n.miDongWatch.\1|g' |
            sed 's|Localized.Huami.string("\([^,]*\)",.[^)]*")|i18n.huami.\1|g' |
            sed 's|Localized.Simplified.string("\([^,]*\)",.[^)]*")|i18n.simplifiedChinese.\1|g' |
            sed 's|Localized.Date.string("\([^,]*\)",.[^)]*")|i18n.dateFormat.\1|g' |
            sed 's|Localized.Weather.string("\([^,]*\)",.[^)]*")|i18n.weather.\1|g' |
            sed 's|Localized.ThirdAuth.string("\([^,]*\)",.[^)]*")|i18n.thirdAuth.\1|g' |
            sed 's|Localized.Lab.string("\([^,]*\)",.[^)]*")|i18n.lab.\1|g' |
            sed 's|Localized.common.string("\([^,]*\)",.[^)]*")|i18n.common.\1|g' |
            sed 's|Localized.StarrySky.string("\([^,]*\)",.[^)]*")|i18n.sky.\1|g' >.tmp

        diff .tmp "$i"
        if [ $? -ne 0 ]; then
            mv .tmp "$i"
        fi

    done

    for i in $(git status | grep  "modified:" | sed 's/^.*modified:[ ]*//g'); do
        if ! [[ $(cat "$i") =~ "import i18n" ]]; then
            sed '1,/^import /s/^import/import i18n\nimport/g' "$i" >.tmp
            mv .tmp "$i"
        fi
    done
}

function forObjc() {

    for i in $(find . -name "*.m"); do

        sed 's|MiDongLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.miDong.\1|g' $i |
            sed 's|MiDongLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.miDong.\1|g' |
            sed 's|PublicLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.public.\1|g' |
            sed 's|HomeLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.home.\1|g' |
            sed 's|SmartLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.smartPlay.\1|g' |
            sed 's|MineLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.mine.\1|g' |
            sed 's|RunLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.run.\1|g' |
            sed 's|HuamiLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.huami.\1|g' |
            sed 's|WeatherLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.weather.\1|g' |
            sed 's|SimplifiedChineseLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.simplifiedChinese.\1|g' |
            sed 's|DateLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.dateFormat.\1|g' |
            sed 's|MiDongWatchLocalizedString(@"\([^,]*\)",.[^)]*")|i18n.miDongWatch.\1|g' |
            sed 's|ThirdAuthLocalizableString(@"\([^,]*\)",.[^)]*")|i18n.thirdAuth.\1|g' |
            sed 's|LabLocalizableString(@"\([^,]*\)",.[^)]*")|i18n.lab.\1|g' |
            sed 's|StarrySkyLocalizableString(@"\([^,]*\)",.[^)]*")|i18n.sky.\1|g' >.tmp

        diff .tmp "$i"
        if [ $? -ne 0 ]; then
            mv .tmp "$i"
        fi

    done

    for i in $(git status | grep  "modified:" | sed 's/^.*modified:[ ]*//g'); do
        if ! [[ $(cat "$i") =~ "@import i18n;" ]]; then
            sed '1,/^[#@]import /s/^\([#@]\)import/@import i18n;\n\1import/' "$i" >.tmp
            mv .tmp "$i"
        fi
    done
}

forSwift
forObjc

rm -rf .tmp
