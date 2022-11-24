#!/bin/bash

name=$1
version=$2

url=$(echo "https://internal-artifactory.zepp.top/release/$version/source/$name.podspec.json" | sed 's/,//g')

curl $url | jq
curl $url | jq ".source.http"
