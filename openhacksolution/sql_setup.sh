#!/bin/bash
# This script assumes that you are running this from the 'poi' directory

# Set ENV variables
. set_variables.sh

context_path=../src/poi

pushd $context_path


docker network create $DOCKER_NETWORK


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

popd