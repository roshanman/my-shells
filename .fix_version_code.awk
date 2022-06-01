BEGIN {
    flag=0
}
{   
    if (flag > 1) {
        print $0
    } else if (flag == 1) {
        gsub("<string>", "")
        gsub("</string>", "")
        print "	<string>"$0+1"</string>"
        flag = 2
    } else if (match($0, ".*HMVersionCode.*")) {
        flag = 1
        print $0
    } else {
        print $0
    }
}