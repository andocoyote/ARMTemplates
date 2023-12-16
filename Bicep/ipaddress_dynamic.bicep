// Creates all resources in the same location as the resource group.

param location string = resourceGroup().location

param IPAddressName string = 'mydynamic-pip'
param publicIPAddressVersion string = 'IPv4'
param publicIPAllocationMethod string = 'Dynamic'

resource IPAddressesDynamic 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: IPAddressName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: publicIPAddressVersion
    publicIPAllocationMethod: publicIPAllocationMethod
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

output IPAddressID string = IPAddressesDynamic.id