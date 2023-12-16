// Creates all resources in the same location as the resource group.
// This template assumes the VNet, subnets, and gateway IP address resources have already been deployed

param location string = resourceGroup().location

param virtualNetworkGatewayName string = 'MyNetwork-vgw'
param IPConfigurationName string = 'gateway-gwipc'
param publicIPAddress_externalid string = ''
param virtualNetworkName string = ''
param addressPrefixes string = '172.16.201.0/28'
param publicCertData string = 'Your .cer string here'
param publicCertName string = 'PS2RootCert'

var gatewaySubnetName = 'GatewaySubnet'

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2023-06-01' = {
  name: virtualNetworkGatewayName
  location: location
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: IPConfigurationName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress_externalid
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, gatewaySubnetName)
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientAddressPool: {
        addressPrefixes: [
          addressPrefixes
        ]
      }
      vpnClientProtocols: [
        'SSTP'
      ]
      vpnAuthenticationTypes: [
        'Certificate'
      ]
      vpnClientRootCertificates: [
        {
          name: publicCertName
          properties: {
            publicCertData: publicCertData
          }
        }
      ]
      vpnClientRevokedCertificates: []
      vngClientConnectionConfigurations: []
      radiusServers: []
      vpnClientIpsecPolicies: []
    }
    customRoutes: {
      addressPrefixes: []
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}