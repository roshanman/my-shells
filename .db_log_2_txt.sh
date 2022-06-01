#!/bin/bash 
if ! [ -f HMLog.sqlite ];then
    echo "当前目录下么有HMLog.sqlite文件啊"
    exit -1
fi

sqlite3 HMLog.sqlite << EOF
select * from log_item;
.quit
EOF
    