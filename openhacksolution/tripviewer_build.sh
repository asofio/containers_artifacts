#!/bin/bash
# This script assumes that you are running this from the 'openhacksolution' directory

# Set ENV variables
. set_variables.sh

image_alias=tripviewer
image_name=tripinsights/tripviewer:1.0
context_path=../src/tripviewer
docker_file=Dockerfile_1
api_port=8082

userprofile_api_endpoint=localhost:8084
trips_api_endpoint=localhost:8081

pushd $context_path

# Build the poi application image
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -f ../../dockerfiles/$docker_file -t "$image_name" .

# 5) Run POI API container in "openhack" docker network

docker run -d -p $api_port:80 --name $image_alias --network $DOCKER_NETWORK -e "USERPROFILE_API_ENDPOINT=http://$userprofile_api_endpoint" -e "TRIPS_API_ENDPOINT=http://$trips_api_endpoint" -e "ASPNETCORE_ENVIRONMENT=Development" $image_name

popd