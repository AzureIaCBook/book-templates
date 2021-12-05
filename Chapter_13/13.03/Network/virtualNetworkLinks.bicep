param linkName string
param privateDnsZoneName string
param virtualNetworkId string

resource link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZoneName}/${linkName}'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: virtualNetworkId
    }
    registrationEnabled: false
  }
}
