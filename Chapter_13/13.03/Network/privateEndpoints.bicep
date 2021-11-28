param serviceName string
param privateLinkServiceId string
param groupIds array
param vnetResourceId string
param subnetName string
param internalHostName string

var resourceName = '${serviceName}-pvtep'

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    privateLinkServiceConnections: [
      {
        name: resourceName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: groupIds
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Automatically Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    customDnsConfigs: [
      {
        fqdn: internalHostName
      }
    ]
    subnet: {
      id: '${vnetResourceId}/subnets/${subnetName}'
    }
  }
}

output ipAddress string = privateEndpoint.properties.customDnsConfigs[0].ipAddresses[0]
