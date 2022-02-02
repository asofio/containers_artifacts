#!/bin/bash

# Set ENV variables
. set_variables.sh

context_path=~/_git/openhack/containers_artifacts/src/poi/

pushd $context_path


docker network create $DOCKER_NETWORK

# Build the poi application image
docker build --no-cache --build-arg IMAGE_VERSION="1.0" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -f Dockerfile -t "tripinsights/poi:1.0" .


# 2) Run SQL Server 2017 container in "openhack" docker network

docker run --network $DOCKER_NETWORK -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SQL_PASSWORD" -p 1433:1433 \
--name $SQL_SERVER -d mcr.microsoft.com/mssql/server:2017-latest

sleep 10
# 3) Create myDrivingDB database

docker exec \
 -it $SQL_SERVER \
 /opt/mssql-tools/bin/sqlcmd \
 -S localhost -U SA -P $SQL_PASSWORD \
 -Q "CREATE DATABASE mydrivingDB"

# 4) Run dataload against local SQL Server

docker run --network $DOCKER_NETWORK -e SQLFQDN=$SQL_SERVER -e SQLUSER=SA -e SQLPASS=$SQL_PASSWORD -e SQLDB=myDrivingDB registryacm8754.azurecr.io/dataload:1.0

# 5) Run POI API container in "openhack" docker network

docker run -d -p 8080:80 --name poi --network $DOCKER_NETWORK -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "SQL_DBNAME=myDrivingDB" -e "SQL_USER=SA" -e "ASPNETCORE_ENVIRONMENT=Local" tripinsights/poi:1.0

# 6) Verify that data can be pull from POI API (using SQL Server backend)

sleep 10

curl -i -X GET 'http://localhost:8080/api/poi'

popd