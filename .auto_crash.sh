#!/bin/bash

# 脚本使用前的配置
# 0. 将该脚本放在~目录下
# 1. brew install jq
# 2. 将以下内容加到 ~/.bashrc 末尾 (或者~/.bash_profile)
#    export PATH="$PATH:$HOME/.rvm/bin:/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/"
#    export DEVELOPER_DIR=/Applications/XCode.app/Contents/Developer
#    alias auto_crash='~/.auto_crash.sh' #
# 3. source ~/.bashrc
# 4. 使用方式是cd到崩溃文件所在目录然后执行命令: auto_crash Zepp-2020-09-24-101801.ips.beta
# https://www.jianshu.com/p/de9aba3aa34f
# python3 /Applications/Xcode.app/Contents/SharedFrameworks/CoreSymbolicationDT.framework/Versions/A/Resources/CrashSymbolicator.py  -d .crash_job_folder/dSYMs/dSYMs/ -o zxm.ips -p EC407E80-E9D8-4B30-B0A6-714AE09FD36A.ips

IFS=$'\n'

crash_file=$1

job_folder="/Users/$(whoami)/Downloads/.crash_job_folder"
result_file="crash_result.ips" # 保存解析结果的文件名称,保存在$job_folder目录下

app_version="" # 6.0.0
bundleID=""    # HM.wristband
versionCode="" # 202111231933
os_version=""  # iPhone OS 15.1 (19B74)
hard_ware=""   # iPhone14,5
branch=""      # mifit/L66
commit=""      # f5763bdd
type=""        # mifit / hollywood / midong
archive_id=""  #下载dsym文件需要用到的参数

function error_echo() {
    message=$1
    echo -e "\033[31m $message \033[0m"
}

function info_echo() {
    message=$1
    echo -e "\033[33m $message \033[0m"
}

function success_echo() {
    message=$1
    echo -e "\033[32m $message \033[0m"
}

function check_user_env() {
    if ! which symbolicatecrash >/dev/null; then
        error_echo "请先将symbolicatecrash命令添加到环境变量"
        exit 1
    fi

    if ! [ -f /Applications/Xcode.app/Contents/SharedFrameworks/CoreSymbolicationDT.framework/Versions/A/Resources/CrashSymbolicator.py ]; then
        error_echo "不存在CrashSymbolicator.py解析脚本"
        exit 1
    fi

    if ! which jq >/dev/null; then
        error_echo "请先安装json解析工具 brew install jq"
        exit 1
    fi
}

function check_user_input() {
    if ! [[ -f "$crash_file" ]]; then
        error_echo "需要提供crash文件"
        exit 1
    fi
}

function print_arch_info() {
    echo -e "appVersion:\033[32m $app_version\033[0m"
    echo -e "bundleID:\033[32m $bundleID\033[0m"
    echo -e "builderNo:\033[32m $versionCode\033[0m"
    echo -e "OS Version:\033[32m $os_version\033[0m"
    echo -e "Hardware Model:\033[32m $hard_ware\033[0m"
    echo -e "branch:\033[32m $branch\033[0m"
    echo -e "commit:\033[32m $commit\033[0m"
}

function get_os_version_from_ips_file() {
    os_version=$(cat $crash_file | grep "OS Version:" | awk -F ":" '{print $2}')
    os_version=$(echo $os_version | grep -o "\w.*")

    if [ -z $os_version ]; then
        os_version=$(cat $crash_file | grep -o "os_version\":\"[^\"]\+" | awk -F"\"" '{print $3}')
    fi
}

function get_hard_ware_from_ips_file() {
    hard_ware=$(cat $crash_file | grep "Hardware Model:" | awk -F ":" '{print $2}')
    hard_ware=$(echo $hard_ware | sed 's/ //g')

    if [ -z $hard_ware ]; then
        hard_ware=$(cat $crash_file | grep -o "modelCode.*iPhone.*\"" | awk -F"\"" '{print $(NF-1)}')
    fi
}

# 12位数字build no
function get_build_version_from_ips_file() {
    versionCode=$(cat $crash_file | grep -o '"build_version":"\d\{12\}' | grep -o "\d\{12\}")

    if [ -z $versionCode ]; then
        versionCode=$(cat $crash_file | grep "^Version:" | grep -o "\d\{12\}")
    fi

    if [ -z $versionCode ]; then
        error_echo "没有找到BuildNumber"
        exit 1
    fi
}

function get_app_version_from_ips_file() {
    app_version=$(cat $crash_file | grep "^Version:.*$versionCode.*" | sed 's/$versionCode//g' | grep -o "\d\+\.\d\+\.\d\+")

    if [[ -z $app_version ]]; then
        app_version=$(cat $crash_file | grep -o "app_version\":\"\d\+.\d\+.\d\+" | awk -F"\"" '{print $3}')
    fi

    if [[ -z $app_version ]]; then
        error_echo "无法从ips文件中提取到appversion"
        exit 1
    fi
}

function get_bundle_id_from_ips_file() {
    bundleID=$(cat $crash_file | grep -o '"bundleID":"[a-z,0-9,A-Z,\.]*' | cut -d'"' -f4)
    if [ -z $bundleID ]; then
        bundleID=$(cat $crash_file | grep "^Identifier:" | awk -F":" '{print $2}' | awk -F" " '{print $1}')
    fi

    if [ -z $bundleID ]; then
        error_echo "没有找到BundleId"
        exit 1
    fi
}

function get_curl_request_type_parameter_from_bundle_id() {
    if [[ $bundleID == "HM.wristband" ]]; then
        type='mifit'
    elif [[ $bundleID == "com.huami.kwatchmanager" ]]; then
        type='hollywood'
    elif [[ $bundleID == "com.huami.watch" ]]; then
        type='midong'
    elif [[ $bundleID == "com.huami.bluetoolth" ]]; then
        type='toolkit' # 蓝牙小工具
    else
        error_echo "暂不支持的APP种类"
        exit 1
    fi
}

function get_arch_info_from_ci_server() {
    archive_info_url="https://open.zepp.top/archive/api/log/notes?versionNumber=$versionCode&versionName=$app_version&type=$type"
    echo "$archive_info_url"

    archive_json=$(curl -s $archive_info_url)
    if [ $? -ne 0 ]; then
        echo -e "\033[31m从CI平台获取archive_url信息失败\033[0m"
        exit 1
    fi

    archive_id=$(echo "$archive_json" | jq ".detail[0].id" | sed 's/"//g')
    branch=$(echo "$archive_json" | jq ".detail[0].branch" | sed 's/"//g')
    commit=$(echo "$archive_json" | jq ".detail[0].currentCommit" | sed 's/"//g')

    if [ -z $archive_id ]; then
        error_echo "从ci获取打包信息失败:$archive_info_url"
        exit 1
    fi
}

function download_dsym_from_server() {
    package_save_path="$job_folder/$versionCode.tgz"
    arch_info_url="https://open.zepp.top/archive/api/log/download?lid=$archive_id&file_type=archive"
    package_download_url=$(curl $arch_info_url | jq ".url" | sed 's/"//g')

    if [[ -z $package_download_url ]]; then
        error_echo "获取dsym下载地址错误: $arch_info_url"
        exit 1
    fi

    if [ -f $package_save_path ]; then
        info_echo "job目录下已缓存过dsym文件无需再次下载"
        return 0
    fi

    curl -o $package_save_path $package_download_url

    if [ $? -ne 0 ]; then
        echo -e "\033[31m下载dsym文件失败\033[0m"
        exit 1
    fi
}

function make_crash_analysis_job_folder() {
    mkdir -p "$job_folder"
}

function unzip_dsym_archive_package() {
    rm -rf ExportArchivePath
    rm -rf MiFit
    rm -rf MiDong
    rm -rf HollyWood
    rm -rf dSYMs

    tar xvf "$job_folder/$versionCode.tgz" -C "$job_folder"
    if [ $? -ne 0 ]; then
        error_echo "解压打包文件失败, 请重试"
        rm -rf "$job_folder/$versionCode.tgz"
        exit 1
    fi

    dsym_zip_path=$(find ExportArchivePath -name "*app.dSYM.zip")

    if [[ -z $dsym_zip_path ]]; then
        error_echo "无法找到dSYM.zip压缩包，可能脚本存在问题"
        exit 1
    fi

    unzip -d dSYMs $dsym_zip_path

    if [[ $? -ne 0 ]]; then
        error_echo "解压dSYM.zip压缩包错误"
        exit 1
    fi
}

function is_after_ios15_crash_format_ips() {
    # iOS15的崩溃是JSON格式
    cat crash.ips | jq > /dev/null
    # version=$(echo $os_version | grep -o "\d\+\.\d" | awk -F"." '{print $1}')
    # if [[ $version -ge 15 ]]; then
    #     return 0
    # else
    #     return 1
    # fi
}

function start_analysis_crash_file() {
    app_dsym_path=$(find dSYMs -name "*.app.dSYM")
    if [[ -z $app_dsym_path ]]; then
        error_echo "无法找到app.dSYM文件，可能存在啥问题"
        exit 1
    fi

    if is_after_ios15_crash_format_ips >/dev/null; then
        python3 /Applications/Xcode.app/Contents/SharedFrameworks/CoreSymbolicationDT.framework/Versions/A/Resources/CrashSymbolicator.py \
            -d $app_dsym_path \
            -o "$job_folder/$result_file" \
            -p crash.ips
    else
        symbolicatecrash \
            -d $app_dsym_path \
            -o "$job_folder/$result_file" crash.ips
    fi

    if [ $? -ne 0 ]; then
        echo -e "\033[31mopus,解析崩溃失败了...\033[0m"
        exit 1
    fi
}

function save_user_current_pwd() {
    pushd .
}

function restore_user_pwd() {
    popd
}

function change_user_pwd_to_job_folder() {
    cd "$job_folder"
}

function copy_crash_file_to_job_folder() {
    cp "$crash_file" "$job_folder/crash.ips"
}

function show_analysis_result() {
    info_echo "即将打开崩溃结果crash_result.ips"
    sleep 1
    open "$job_folder/$result_file"
}

check_user_env
check_user_input
get_os_version_from_ips_file
get_hard_ware_from_ips_file
get_app_version_from_ips_file
get_build_version_from_ips_file
get_bundle_id_from_ips_file
get_curl_request_type_parameter_from_bundle_id
get_arch_info_from_ci_server
print_arch_info
save_user_current_pwd
make_crash_analysis_job_folder
copy_crash_file_to_job_folder
change_user_pwd_to_job_folder
download_dsym_from_server
unzip_dsym_archive_package
start_analysis_crash_file
show_analysis_result
restore_user_pwd
