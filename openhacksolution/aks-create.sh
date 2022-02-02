export RESOURCE_GROUP=teamResources
export CLUSTER_NAME=OpenHackTeam7
export MYACR=registryacm8754

az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --node-count 1 \
    --enable-addons http_application_routing \
    --generate-ssh-keys \
    --node-vm-size Standard_B2s \
    --network-plugin kubenet  \
	--attach-acr $MYACR \
	--generate-ssh-keys
	
az aks nodepool add \
    --resource-group $RESOURCE_GROUP \
    --cluster-name $CLUSTER_NAME \
    --name userpool \
    --node-count 1 \
    --node-vm-size Standard_B2s
	
az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP

kubectl get nodes
