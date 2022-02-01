# Perform docker system prune

docker system prune

# 1) Create docker network named "openhack"

docker network create $DOCKER_NETWORK

# 2) Run SQL Server 2017 container in "openhack" docker network

docker run --network $DOCKER_NETWORK -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=lM3am0Rf9" -p 1433:1433 \
--name sqlserver -d mcr.microsoft.com/mssql/server:2017-latest 

# 3) Adjust sa name and change to sqladmin 

# ALTER LOGIN [sa] WITH NAME = [sqladmin]

# 4) Create myDrivingDB database

# CREATE DATABASE myDrivingDB;

# 5) Build POI API container

docker build -f Dockerfile -t "tripinsights/poi:1.0" .

# 6) Run POI API container in "openhack" docker network

docker run -d -p 8080:80 --name poi --network $DOCKER_NETWORK \
-e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "SQL_DBNAME=myDrivingDB" \
-e "SQL_USER=sqladmin" tripinsights/poi:1.0

# 7) Run dataload against local SQL Server

docker run --network $DOCKER_NETWORK -e SQLFQDN=localhost -e SQLUSER=sqladmin -e SQLPASS=lM3am0Rf9 -e SQLDB=myDrivingDB registryacm8754.azurecr.io/dataload:1.0

# 8) Verify that data can be pull from POI API (using SQL Server backend)

curl -i -X GET 'http://localhost:8080/api/poi' 