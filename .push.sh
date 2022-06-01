#!/bin/bash

topic=$1

current_branche=$(git branch | grep "^\*" | awk '{print $2}')

if [[ -z $topic ]]; then
    git push origin head:refs/for/$current_branche
else
    git push origin head:refs/for/$current_branche%topic=$topic
fi
