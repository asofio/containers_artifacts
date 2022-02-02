#!/bin/bash

az login

docker login

. set_variables.sh

# Login to the registry
# username: registryacm8754
# Password: yFjrKAqR=wAe193eE5stg3KqCHrioq9d
az acr login -n $ACR_NAME -u $ACR_USERNAME -p $ACR_PASSWORD
