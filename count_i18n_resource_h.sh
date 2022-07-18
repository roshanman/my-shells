#!/bin/bash

IFS=$'\n'

# ➜  midong git:(midong/6.7.0) ✗ grep -E -r --include="*.h" --include="*.m" --include="*.swift" 'MineLocalizedString\(@"bind_fail"|Localized.Mine.string\("bind_fail"' | awk -F":" '{print $1}' | awk -F"/" '{print $2"/"$3}' | sort | uniq
# MiFit/App
# Pods/HMAccountServices

# exclude_Pods="DoraemonKit;GBDeviceInfo;ThemeSetting;RxSwift;RxCocoa;APM;Moya;HttpKit;HMCache;HMCategory;AFNetworking;AMapFoundation;AMap3DMap;AMapLocation;HMDBFirstBeat;HMPersistance;HMLog;MagicalRecord;MMKV;MMKVCore;HMTranslate;Parchment;Healthcare;Headers;QuickLayout;Protobuf;PromisesObjC;RainbowKit;RainbowKitZepp;Reusable;RxRelay;TrustKit;UIAlertController+Blocks;firmware.ios;eigen;lottie-ios;objc-geohash;nanopb;GoogleSignIn;GTMAppAuth;GDataXML-HTML;GCDWebServer;GTMSessionFetcher;GoogleAppMeasurement;GoogleDataTransport;GoogleUtilities;HMVendor;HMSQLite;HMImage;IGListKit;IGListDiffKit;FSCalendar;FBSDKCoreKit;FBSDKLoginKit;FBRetainCycleDetector;FirebaseCrashlytics;FirebaseABTesting;FirebaseAnalytics;FirebaseCore;FirebaseCoreDiagnostics;FirebaseInstallations;FirebasePerformance;FirebaseRemoteConfig;FormatKit;"

# for pod in $(echo $exclude_Pods | sed 's/;/\n/g');do
#     grep_exclude_dirs="$grep_exclude_dirs"" --exclude-dir=./Pods/$pod --exclude-dir=./Pods/$pod.xcodeproj"
# done
# echo $grep_exclude_dirs
# exit 0

# grep_exclude_dirs="--exclude-dir=./Pods/HMTranslate --exclude-dir-dir=Pods/HMTranslate.xcodeproj/"

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
    ) | sort | uniq | grep -v DoraemonLocalizedString | grep -v PELocalizedString
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

function count_every_i18n_res() {
    for i18n in $(merge_swift_oc_i18n_res); do

        oc_regx=$(get_oc_regex_with_i18n_foler_and_key "$i18n")

        objc=$(grep -E -r -o --include="*.h" "$oc_regx")
        # swift=$(grep -E -r -o -l --include="*.swift" "$swift_regx")

        # # count_swift=$(echo "$swift" | grep "\./" | wc -l)
        # # count_objc=$(echo "$objc" | grep "\./" | wc -l)
        # # count=$(($count_swift + $count_objc))

        echo "\n## ${i18n}""\n$objc"

    done
}

count_every_i18n_res