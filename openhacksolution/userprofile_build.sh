#!/bin/bash
# This script assumes that you are running this from the 'openhacksolution' directory

# Set ENV variables
. set_variables.sh

image_alias=userprofile
image_name=tripinsights/userprofile:1.0
context_path=../src/userprofile
docker_file=Dockerfile_2
api_port=8084

pushd $context_path

# Build the poi application image
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -f ../../dockerfiles/$docker_file -t "$image_name" .

# 5) Run POI API container in "openhack" docker network

docker run -d -p $api_port:80 --name $image_alias --network $DOCKER_NETWORK -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "SQL_DBNAME=myDrivingDB" -e "SQL_USER=SA" $image_name

sleep 5

curl -i -X GET "http://localhost:$api_port/api/user"

popd