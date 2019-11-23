#!/bin/bash


# docker run -d -p 6379:6379 redis
# docker run -d -p 9200:9200 elasticsearch:2.3.5



context=.
container="castle-latest"
version="latest"
image="realworldio/castlecms:$version"
cmd="docker build -t $image $context"

function base_installer {
    cmd="docker build -t $image $context"
    echo ">>>> Build image: $image"
    echo "---> $cmd"
    $cmd

    cmd="docker run -d -p 8080:8080 -e SITE='Castle' --name $container $image"
    echo ">>>> Run container: $container"
    echo "---> $cmd"
    $cmd
    
    sleep 30s
    docker logs $container

    cmd="docker exec $container ./bin/test -s castle.cms -t \!robot"
    echo ">>>> Test container: $container"
    echo "---> $cmd"
    $cmd

    cmd="docker stop $container"
    echo ">>>> Stop container: $container"
    echo "---> $cmd"
    $cmd

    cmd="docker rm $container"
    echo ">>>> Remove container: $container"
    echo "---> $cmd"
    $cmd
}

base_installer

for file in $(find ./*/ -type f -name 'Dockerfile'); do
    context="$(dirname $file)"
    based_os="$(dirname $context)"
    version="$(basename $based_os)"
    image="realworldio/castlecms:$version"
    container="castle-$version"
    echo "Building image for Castle:$version"
    base_installer
    # cmd="docker rmi $image"
    # echo ">>>> Remove container: $image"
    # echo "---> $cmd"
    # $cmd
done