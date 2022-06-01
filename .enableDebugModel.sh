set -e

plist=$(find . -maxdepth 5 -name "BuildConfig.plist")

if [[ -z $plist ]];then
    echo -e "\033[32m没有找到BuildConfig.plist文件\033[0m"
    exit 1
fi

awk -f "/Users/zhangxiuming/.enableDebugModel.awk" "$plist" > ".new_build_config.plist"

mv ".new_build_config.plist" "$plist"