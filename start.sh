#!/bin/bash 
VERSION="$(cat ./VERSION)"

if [ $1 != "dry-run" ]
then
echo "Ingrese una version [$VERSION]"
read VERS

if [ ! -z $VERS ]
then
    VERSION=$VERS
fi

fi

echo "Version: $VERSION";

echo $VERSION > ./VERSION

docker build -t janus-server:latest .
