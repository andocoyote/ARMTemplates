// To deploy:
// az deployment group create --name VNetGatewayDeployment --resource-group MyResourceGroup --parameters virtualnetworkgateway_parameters.bicepparam
// az deployment group create -n VNetGatewayDeployment -g MyResourceGroup -p virtualnetworkgateway_parameters.bicepparam

using './/virtualnetworkgateway.bicep'

param virtualNetworkGatewayName = 'MyNetwork-vgw'
param publicIPAddress_externalid = null
param virtualNetworkName = null
param addressPrefixes = '172.16.201.0/28'
param publicCertData = null