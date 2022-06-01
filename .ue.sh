#!/bin/bash

event_type=$1

function error_echo() {
    echo -e "\033[31m$1\033[32m"
}

echo -e "\033[31m*\033[0m请输入用户ID(默认 1079702073):\c"
read user_id
echo -e "\033[31m*\033[0m请输入Event Type(默认 PaiHealthInfo):\c"
read event_type
echo -e "请输入Event Sub Type:\c"
read event_sub_type
echo -e "请输入from date(YYYY.MM.DD):\c"
read from_date
echo -e "请输入to date(YYYY.MM.DD):\c"
read to_date

if [ -z $user_id ]; then
    user_id="1079702073"
fi

if [ -z $event_type ]; then
    event_type="PaiHealthInfo"
fi

if [ -z $from_date ]; then
    from_date="2016.01.01"
fi

if [ -z $to_date ]; then
    to_date=$(date "+%Y.%m.%d")
fi

echo -e "\033[32m用户ID：$user_id\033[0m"
echo -e "\033[32mEvent Type：$event_type\033[0m"
echo -e "\033[32mEvent Sub Type：$event_sub_type\033[0m"
echo -e "\033[32mFrom：$from_date\033[0m"
echo -e "\033[32mTo：$to_date\033[0m"

from_date=$(date -j -f "%Y.%m.%d %H.%M.%S" "$from_date 00.00.00" "+%s")
to_date=$(date -j -f "%Y.%m.%d %H.%M.%S" "$to_date 00.00.00" "+%s")

sleep 2

curl --location --request GET 'https://mifit-device-service-private-cn2.huami.com/users/'$user_id'/events?eventType='$event_type'&from='$from_date'000&limit=1000&to='$to_date'000' \
    --header 'app_token: NQVBQFZCPmpHSm56LntKMmo2Jlpya0p6PjwEAAQAAAACOGcruhBlAH7T0Wo8bGCLBdpHQNsG6LT23NgpOmxe3JSZz9SOEGBvl_DyQnA8l53UvNFAzQP6S2JKnLWcFqfROBTWPAzwek35he4Zx_ebronc50IoatdMGQ9B2L2K0kjFkB-tpzpFrIZ-rCHX3W5nY4HCPzMeeG5lYMU86hJ-l2u0y3PjfyQLRvRFbvbQGaA0' \
    --header 'appname: com.xiaomi.hm.health' | jq
