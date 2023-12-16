targetScope='subscription'

param resourceGroupLocation string = deployment().location

param resourceGroupName string = 'MyResourceGroup-rg'
param virtualNetworkName string = 'MyNetwork-vnet'
param IPAddressName string = 'gateway-pip'
param virtualNetworkGatewayName string = 'MyNetwork-vgw'


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
  }
  dependsOn: [
    resourceGroupModule
	VNetModule
	GatewayIPAddressModule
  ]
}