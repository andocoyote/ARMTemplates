// To deploy:
// az deployment group create --name VNetGatewayDeployment --resource-group MyResourceGroup --parameters virtualnetworkgateway_parameters.bicepparam
// az deployment group create -n VNetGatewayDeployment -g MyResourceGroup -p virtualnetworkgateway_parameters.bicepparam

using './/virtualnetworkgateway.bicep'

param virtualNetworkGatewayName = 'MyNetwork-vgw'
param virtualNetworkName = 'MyNetwork-vnet'
param addressPrefixes = '172.16.201.0/28'

// These parameters must be provided for the Bicep deployment to work
param publicIPAddress_externalid = ''
param publicCertData = ''