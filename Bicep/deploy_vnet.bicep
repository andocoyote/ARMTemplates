targetScope='subscription'

param resourceGroupLocation string = deployment().location
param subscriptionID string = subscription().subscriptionId

param resourceGroupName string = 'MyResourceGroup-rg'
param virtualNetworkName string = 'MyNetwork-vnet'
param IPAddressName string = 'gateway-pip'
param virtualNetworkGatewayName string = 'MyNetwork-vgw'

param keyVaultResourceGroupName string = 'ando_general_resource'
param keyVaultName string = 'kv-general-key-vault'
param cerSecretName string = 'PS2RootCert-PublicCertificateData'


resource myKv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
  scope: resourceGroup(subscriptionID, keyVaultResourceGroupName)
}

// Deploy the resource group
module resourceGroupModule '../resource_group.bicep' = {
  name: 'GroupDeployment'
  params: {
    resourceGroupName: resourceGroupName
	resourceGroupLocation: resourceGroupLocation
  }
}

// Deploy the virtual network
module VNetModule '../virtualnetwork_frontend_backend.bicep' = {
  name: 'VNetDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: resourceGroupLocation
	virtualNetworkName: virtualNetworkName
  }
  dependsOn: [
    resourceGroupModule
  ]
}

// Deploy the virtual network gateway public IP address
module GatewayIPAddressModule '../ipaddress_dynamic.bicep' = {
  name: 'IPAddressDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: resourceGroupLocation
	IPAddressName: IPAddressName
  }
  dependsOn: [
    resourceGroupModule
  ]
}

// Deploy the virtual network gateway
module GatewayModule '../virtualnetworkgateway.bicep' = {
  name: 'VNetGatewayDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: resourceGroupLocation
	virtualNetworkName: VNetModule.outputs.virtualNetworkName
	publicIPAddress_externalid: GatewayIPAddressModule.outputs.IPAddressID
	virtualNetworkGatewayName: virtualNetworkGatewayName
	publicCertData: myKv.getSecret(cerSecretName)
  }
  dependsOn: [
    resourceGroupModule
	VNetModule
	GatewayIPAddressModule
  ]
}