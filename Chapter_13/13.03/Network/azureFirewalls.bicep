param defaultResourceName string
@allowed([
  'dev'
  'tst'
  'prd'
])
param environmentCode string

param vnetResourceId string
param publicIpAddressName string
param publicIpAddressId string
param firewallPolicyId string

var resourceName = '${defaultResourceName}-fw'
var firewallTier = environmentCode == 'prod' ? 'Standard' : 'Standard'

resource firewall 'Microsoft.Network/azureFirewalls@2021-03-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: publicIpAddressName
        properties: {
          publicIPAddress: {
            id: publicIpAddressId
          }
          subnet: {
            id: '${vnetResourceId}/subnets/AzureFirewallSubnet'
          }
        }
      }
    ]
    firewallPolicy: {
      id: firewallPolicyId
    }
    sku: {
      tier: firewallTier
    }
  }
}
