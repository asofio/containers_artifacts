export RESOURCE_GROUP=teamResources
export CLUSTER_NAME=OpenHackTeam7
export MYACR=registryacm8754
export LOCATION=westus
export VNET=vnet

SUBNET_ID=$(az network vnet subnet create -g $RESOURCE_GROUP --vnet-name $VNET --name akssubnet --address-prefixes 10.2.1.0/24 -o none)

az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --node-count 1 \
    --node-vm-size Standard_B2s \
    --network-plugin azure  \
    --enable-managed-identity
	--attach-acr $MYACR \
	--generate-ssh-keys
	--enable-aad \
    --enable-azure-rbac \
    --vnet-subnet-id $SUBNET_ID \
    --docker-bridge-address 172.17.0.1/16 \
    --dns-service-ip 10.2.1.10 \
    --service-cidr 10.2.1.0/24 

az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP

kubectl get nodes
