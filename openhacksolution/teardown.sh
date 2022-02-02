#!/bin/bash

# az login

# docker login

. set_variables.sh

# Login to the registry
# username: registryacm8754
# Password: yFjrKAqR=wAe193eE5stg3KqCHrioq9d
#sudo az acr login -n $ACR_NAME -u $ACR_USERNAME -p $ACR_PASSWORD

# Stop any containers that are currently running
docker stop container $SQL_SERVER && docker rm container $SQL_SERVER
docker stop container poi && docker rm container poi


# To additionally remove any stopped containers and all unused images
#  (not just dangling images), add the -a flag to the command:

docker system prune -a
