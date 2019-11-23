#!/bin/bash

context=.
container="castle-latest"
version="latest"
image="realworldio/castlecms:$version"
cmd="docker build -t $image $context"


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
    git add release/*
    git status

    echo "---> Commit changes for castlecms:$version"
    git commit -m "Build castlecms:$version image"

    echo "---> Build tag for castlecms:$version"
    git tag -a v$version -m "Release realworldio/castlecms:$version image"
    git checkout master

    git branch -D tagit

    
    echo "---> Clean up"
    rm release/Dockerfile
    rm release/docker-entrypoint.sh
    rm release/docker-initialize.py

done



