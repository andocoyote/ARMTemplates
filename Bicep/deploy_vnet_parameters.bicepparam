// To deploy:
// az deployment sub create --name CompleteVNetDeployment --location westus3 --parameters deploy_vnet_parameters.bicepparam
// az deployment sub create -n CompleteVNetDeployment -l westus3 -p deploy_vnet_parameters.bicepparam

using './/deploy_vnet.bicep'

param resourceGroupName = 'MyResourceGroup-rg'
param virtualNetworkName = 'MyNetwork-vnet'
param IPAddressName = 'gateway-pip'
param virtualNetworkGatewayName = 'MyNetwork-vgw'