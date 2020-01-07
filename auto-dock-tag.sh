#!/bin/bash

context=.
container="castle-latest"
version="latest"
image="realworldio/castlecms:$version"
cmd="docker build -t $image $context"
deleteTags="No"

while getopts "hd" arg; do
  case $arg in
    h)
      echo "usage" 
    ;;
    d)
      deleteTags="Yes"
    ;;
    \?)
      echo "WRONG" >&2
    ;;
  esac
done

for file in $(find ./*/ -type f -name 'Dockerfile'); do
    context="$(dirname $file)"
    based_os="$(dirname $context)"
    version="$(basename $based_os)"
    image="realworldio/castlecms:$version"

    echo "---> Switch to tagit"
    git checkout -b tagit
    
    echo "---> Clone files to tagit"
    cp $context/* ./release/
    git status
    git add release
    git status

    echo "---> Commit changes for castlecms:$version"
    git commit -m "Build castlecms:$version image"

    echo "---> Build tag for castlecms:$version"
    git tag -a v$version -m "Release realworldio/castlecms:$version image"
    git checkout master

    git branch -D tagit

    
    echo "---> Clean up"
    rm -f release/Dockerfile
    rm -f release/docker-entrypoint.sh
    rm -f release/docker-initialize.py
    
    if [ "$deleteTags" == "Yes" ]; then
        git push --delete origin v$version
    fi

done



