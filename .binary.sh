#!/bin/bash

name=$1
version=$2

url=$(echo "https://cart.athuami.com/release/$version/binary/$name.podspec.json" | sed 's/,//g')

curl $url | jq
curl $url | jq ".source.http"