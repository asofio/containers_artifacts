#!/bin/bash
# This script assumes that you are running this from the 'openhacksolution' directory

# Set ENV variables
. set_variables.sh

context_path=../src/poi

pushd $context_path

# Build the poi application image
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -f ../../dockerfiles/Dockerfile_3 -t "tripinsights/poi:1.0" .

# 5) Run POI API container in "openhack" docker network

docker run -d -p 8080:80 --name poi --network $DOCKER_NETWORK -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "SQL_DBNAME=myDrivingDB" -e "SQL_USER=SA" -e "ASPNETCORE_ENVIRONMENT=Local" tripinsights/poi:1.0

# 6) Verify that data can be pull from POI API (using SQL Server backend)

sleep 10

curl -i -X GET 'http://localhost:8080/api/poi'

popd