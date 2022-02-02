. set_variables.sh

# Login to the registry
# username: registryacm8754
# Password: yFjrKAqR=wAe193eE5stg3KqCHrioq9d
az acr login -n $ACR_NAME -u $ACR_USERNAME -p $ACR_PASSWORD

docker tag tripinsights/poi:1.0 registryacm8754.azurecr.io/poi:1.0
docker tag tripinsights/trips:1.0 registryacm8754.azurecr.io/trips:1.0
docker tag tripinsights/tripviewer:1.0 registryacm8754.azurecr.io/tripviewer:1.0
docker tag tripinsights/userjava:1.0 registryacm8754.azurecr.io/userjava:1.0
docker tag tripinsights/userprofile:1.0 registryacm8754.azurecr.io/userprofile:1.0

docker push registryacm8754.azurecr.io/poi:1.0
docker push registryacm8754.azurecr.io/trips:1.0 
docker push registryacm8754.azurecr.io/tripviewer:1.0
docker push registryacm8754.azurecr.io/userjava:1.0 
docker push registryacm8754.azurecr.io/userprofile:1.0 
