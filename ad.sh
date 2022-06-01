#!/bin/bash

function error_echo() {
    echo -e "\033[31m$1\033[32m"
}

echo -e "\033[31m*\033[0m请输入用户ID:\c"
read user_id
echo -e "请输入查询日期date(YYYY.MM.DD):\c"
read from_date

if [ -z $user_id ]; then
    error_echo "请输入正确的用户ID"
fi

if [ -z $from_date ]; then
    from_date="请输入正确的查询日期"
fi

echo -e "\033[32m用户ID：$user_id\033[0m"
echo -e "\033[32m查询日期：$from_date\033[0m"

from_date=$(date -j -f "%Y.%m.%d %H.%M.%S" "$from_date 00.00.00" "+%s")

request=$(
    curl 'https://api-admin-cn.huami.com/huami-admin/deviceDatas?appName=com.xiaomi.hm.health&userId='$user_id'&startDay='$from_date'&endDay='$((from_date + 86400))'' \
        -X 'GET' \
        -H 'Accept: application/json' \
        -H 'Origin: https://admin.huami.com' \
        -H 'Authorization: Xd881c6d109354ecda67a030b3a4c46ae' \
        -H 'Referer: https://admin.huami.com/' \
        -H 'Host: api-admin-cn.huami.com' \
        -H 'Accept-Language: zh-CN,zh-Hans;q=0.9' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15' \
        -H 'Accept-Encoding: gzip, deflate, br' \
        -H 'Connection: keep-alive' \
        -H 'X-Request-Id: f1c4df68-fc74-4f40-bfd1-3ec14cbfad4b'
)

if [ $? -ne 0 ];then
    echo "网络请求失败"
    exit -1
fi

rawData=$(echo $request | jq ".[0].mergedRawData")

echo $rawData | swift activity_data.swift