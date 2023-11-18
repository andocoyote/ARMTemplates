// Creates a small VNet with two subnets each with 255 possible addresses by default.
// Creates all resources in the same location as the resource group.

param location string = resourceGroup().location
param virtualNetworkName string = 'MyNetwork-vnet'
param frontendSubnetName string = 'Frontend'
param backendSubnetName string = 'Backend'
param virtualNetworkRange string = '10.1.0.0/23'
param frontendSubnetRange string = '10.1.0.0/24'
param backendSubnetRange string = '10.1.1.0/24'

var frontendNsgName = '${frontendSubnetName}-nsg'
var backendNsgName = '${backendSubnetName}-nsg'

resource frontendNsg 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: frontendNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          description: 'Remote Desktop (RDP) Connection'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource frontendNsgName_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2020-05-01' = {
  parent: frontendNsg
  name: 'RDP'
  properties: {
    description: 'Remote Desktop (RDP) Connection'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource backendNsg 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: backendNsgName
  location: location
  properties: {
    securityRules: []
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkRange
      ]
    }
    subnets: [
      {
        name: frontendSubnetName
        properties: {
          addressPrefix: frontendSubnetRange
          networkSecurityGroup: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', frontendNsgName)
          }
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: backendSubnetName
        properties: {
          addressPrefix: backendSubnetRange
          networkSecurityGroup: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', backendNsgName)
          }
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
    enableVmProtection: false
  }
  dependsOn: [
    frontendNsg
    backendNsg
  ]
}