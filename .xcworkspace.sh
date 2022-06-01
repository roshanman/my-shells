
#!/bin/bash

xcworkspace_count=$(find . -maxdepth 3 -name "*.xcworkspace" | awk '{ if (!match($0, "project")) print $0 }' | wc -l)

if [ $xcworkspace_count -eq 0 ];then 
    echo -e "\033[031m没有找到工程文件\033[031m"
    exit 1
fi

if [ $xcworkspace_count -eq 1 ];then 
    open $(find . -maxdepth 3 -name "*.xcworkspace" | awk '{ if (!match($0, "project")) print $0 }')
    exit 0
fi

PS3="请选择您要打开的工程:"

select i in $(find . -maxdepth 3 -name "*.xcworkspace" | awk '{ if (!match($0, "project")) print $0 }'); do
    open $i
    break
done

