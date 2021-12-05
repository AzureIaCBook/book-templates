param defaultResourceName string

var resourceName = '${defaultResourceName}-pip'

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

output ipAddress string = publicIpAddress.properties.ipAddress
output pulicIpAddressName string = publicIpAddress.name
output pulicIpAddressId string = publicIpAddress.id
