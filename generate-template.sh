#!/bin/bash

vCastle=2.5.0
vFolder=2.5/$vCastle
vMD5="$(echo -n "$vFolder" | md5sum | sed 's/ .*$//')"

for i in $(seq $2 $3); do
    vCastle=$1.$i
    vFolder=$1/$vCastle/debian
    vMD5="$(echo -n "$vFolder" | md5sum | sed 's/ .*$//')"
    skipped=0
    mkdir -p $vFolder
    echo "Processing $vFolder folder"
    if [ ! -e "$vFolder/docker-initialize.py" ]; then
        echo "---> Copying docker-initialize.py into $vFolder"
        cp docker-initialize.py $vFolder/
    fi
    if [ ! -e "$vFolder/docker-entrypoint.sh" ]; then
        echo "---> Copying docker-entrypoint.sh into $vFolder"
        cp docker-entrypoint.sh $vFolder/
    fi
    if [ ! -e "$vFolder/Dockerfile" ]; then
        echo "---> Copying Dockerfile into $vFolder"
        cp Dockerfile $vFolder/
        echo "---> Setting Dockerfile to $vCastle";
        sed -i -e "s/\-\-branch\smaster/--branch $vCastle/" $vFolder/Dockerfile
        sed -i -e "s/CASTLE_MAJOR\=2.5/CASTLE_MAJOR=$1/" $vFolder/Dockerfile
        sed -i -e "s/CASTLE_VERSION\=2.5.x/CASTLE_VERSION=$vCastle/" $vFolder/Dockerfile
        sed -i -e "s/CASTLE_MD5=8ed5ff27fab67b1b510a1ce0ee2dd655/CASTLE_MD5=$vMD5/" $vFolder/Dockerfile
    fi
    
done

chmod -R 755 ./*/