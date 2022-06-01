#!/bin/bash

current_branch=$(git branch | grep "^*" | awk '{print $2}')

cat .git/config | sed "s|fetch = +refs.*|fetch = +refs/heads/$current_branch:refs/remotes/origin/$current_branch|g" > /tmp/.link_branch.config

mv /tmp/.link_branch.config .git/config