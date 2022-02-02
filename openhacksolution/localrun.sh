SQL_SERVER=sqlserver
SQL_PASSWORD=lM3am0Rf9
DOCKER_NETWORK=openhack

docker stop $SQL_SERVER && docker rm $SQL_SERVER
docker stop poi && docker rm poi

# 1) Create docker network named "openhack"

docker network create $DOCKER_NETWORK

# 2) Run SQL Server 2017 container in "openhack" docker network

docker run --network $DOCKER_NETWORK -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SQL_PASSWORD" -p 1433:1433 \
--name $SQL_SERVER -d mcr.microsoft.com/mssql/server:2017-latest 

sleep 2

# 3) Create myDrivingDB database

docker exec \
 -it $SQL_SERVER \
 /opt/mssql-tools/bin/sqlcmd \
 -S localhost -U SA -P $SQL_PASSWORD \
 -Q "CREATE DATABASE myDrivingDB"

sleep 2
# # 4) Run dataload against local SQL Server

docker run --network $DOCKER_NETWORK -e SQLFQDN=$SQL_SERVER -e SQLUSER=SA -e SQLPASS=$SQL_PASSWORD -e SQLDB=myDrivingDB registryacm8754.azurecr.io/dataload:1.0

# 5) Run POI API container in "openhack" docker network

docker run -d -p 8080:80 --name poi --network $DOCKER_NETWORK \
-e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "SQL_DBNAME=myDrivingDB" \
-e "SQL_USER=SA" -e "ASPNETCORE_ENVIRONMENT=Local" tripinsights/poi:1.0

# Verify that data can be pulled from POI API (using SQL Server backend)

sleep 5

curl -i -X GET 'http://localhost:8080/api/poi' 