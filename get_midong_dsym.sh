#!/bin/bash

if ! which jq >/dev/null; then
    echo -e "\033[33m请先安装json解析工具 brew install jq\033[0m"
    exit 1
fi

if [ $# -lt 1 ]; then
    echo -e "\033[31m需要提供VersionCode\033[0m"
    exit 1
fi

versionCode=$1

##############################################################ArchiveURL##################################################
echo -e "\033[34m正在加载打包信息\033[0m"

archive_info_url="https://open.zepp.top/archive/api/log/notes?versionNumber=$versionCode&versionName=$app_version&type=midong"

echo $archive_info_url

#archive_info_url='https://api-archive.athuami.com/api/log/notes?versionCode='$versionCode'&versionName='$app_version'&type=midong'
archive_json=$(curl -s $archive_info_url)

if [ $? -ne 0 ]; then
    echo -e "\033[31m从CI平台获取archive_url信息失败\033[0m"
    exit 1
fi

archive_url=$(echo "$archive_json" | jq ".detail[0].archive_url" | sed 's/"//g')
branch=$(echo "$archive_json" | jq ".detail[0].branch")
commit=$(echo "$archive_json" | jq ".detail[0].currentCommit")
versionName=$(echo "$archive_json" | jq ".detail[0].versionName")
versionCode=$(echo "$archive_json" | jq ".detail[0].versionCode")
job_build_reason=$(echo "$archive_json" | jq ".detail[0].job_build_reason")
archive_id=$(echo "$archive_json" | jq ".detail[0].id" | sed 's/"//g')

if [ -z $archive_url ]; then
    echo -e "\033[31m获取archive_url失败\033[0m"
    exit 1
fi

echo -e "builderNo:\033[32m$versionCode\033[0m"
echo -e "branch:\033[32m$branch\033[0m"
echo -e "commit:\033[32m$commit\033[0m"
echo -e "versionName:\033[32m$versionName\033[0m"
echo -e "versionCode:\033[32m$versionCode\033[0m"
echo -e "job_build_reason:\033[32m$job_build_reason\033[0m"

sleep 6

##############################################################dsymURL##################################################
echo -e "\033[34m正在下载dsym文件\033[0m"
# https://api-archive.athuami.com/api/log/MiDong-iOS-TestFlight_archive_20200509_13_50_42.tgz
arch_info_url="https://open.zepp.top/archive/api/log/download?lid=$archive_id&file_type=archive"
package_download_url=$(curl $arch_info_url | jq ".url" | sed 's/"//g')

echo ">>> $dsym_download_url, $package_download_url"

curl -o "$versionCode.tgz" "$package_download_url"

if [ $? -ne 0 ]; then
    echo -e "\033[31m获取dsym文件失败\033[0m"
    exit 1
fi

echo "已下载dsym文件: $versionCode.tgz"
