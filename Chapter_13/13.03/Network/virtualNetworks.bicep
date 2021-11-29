param defaultResourceName string

param addressPrefixes array
param subnets array

var resourceName = '${defaultResourceName}-vnet'

resource network 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
        delegations: subnet.delegations
      }
    }]
  }
}

output resourceName string = resourceName
output subscriptionResourceId string = network.id
