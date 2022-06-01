#!/bin/bash
set -e

IFS=$'\n'
tag="$1"

if [ -z "$tag" ]; then
    echo "请提供tag"
    exit 0
fi

huami_pod_spec_path="/Users/$(whoami)/.cocoapods/repos/huami-apps-specs-ios"

function update_huami_pod_spec() {
    git -C "$huami_pod_spec_path" reset --hard HEAD~10
    git -C "$huami_pod_spec_path" clean -fd .
    git -C "$huami_pod_spec_path" pull --rebase
}

function commit_huami_pod_spec() {
    podname="$1"
    version="$2"
    commit_message="[Update] $podname ($version)"

    git -C "$huami_pod_spec_path" add .
    git -C "$huami_pod_spec_path" commit -m "$commit_message"
}

function push_huami_pod_spec_to_gerrit() {
    git -C "$huami_pod_spec_path" push origin head:refs/for/master
}

function change_spec_version() {
    podspec="$1"
    version="$2"

    sed "s/\(.*s.version.*=\)\(.*\)/\1 \'$version\'/" $podspec
}

function copy_spec_to_huami_spec_repo() {
    podname="$1"
    podspec="$2"
    version="$3"

    dst="/Users/$(whoami)/.cocoapods/repos/huami-apps-specs-ios/$podname/$version"

    mkdir -p "$dst"

    cp "$podspec" "$dst/$podname.podspec"
}

# 应付单仓库多组件
function get_verion_from_tag() {
    # bloodpressure/1.4.3 > 1.4.3
    tag="$1"
    echo "$tag" | sed 's/.*\///g'
}

# 应付单仓库多组件
function get_podspec_from_tag() {
    # bloodpressure/1.4.3 > bloodpressure
    tag="$1"
    echo "$tag" | grep -o ".*/" | sed "s/\///g"
}

version=$(get_verion_from_tag "$tag")
special_pod_spec=$(get_podspec_from_tag "$tag")

update_huami_pod_spec

for spec in $(find . -name "*.podspec" -maxdepth 1 | grep -i "$special_pod_spec"); do
    name=$(echo $spec | sed 's/.\///g' | sed 's/.podspec//g')
    change_spec_version "$spec" "$version" >.temp.txt
    copy_spec_to_huami_spec_repo "$name" ".temp.txt" "$version"
    commit_huami_pod_spec "$name" "$version"
    rm .temp.txt
done

push_huami_pod_spec_to_gerrit

git tag "$tag"

echo "spec已推送到Gerrit，确认无误submit后请将当前组件的tag push到gerrit"
