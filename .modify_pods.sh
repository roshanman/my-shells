#!/bin/bash

git status | grep ' Pods/' | awk -F':' '{print $2}' | awk -F'/' '{print $2}' | awk -F'.' '{print $1}' | sort | uniq
