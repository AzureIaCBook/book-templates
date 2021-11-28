param defaultResourceName string
param vnetSubscriptionResourceId string
param internalDomainName string
param networkingResourceGroupName string

var host = 'events'
var hostname = '${host}.${internalDomainName}'

module eventGridModule 'EventGrid/domains.bicep' = {
  name: 'eventGridModule'
  params: {
    defaultResourceName: defaultResourceName
  }
}

module privateEndpointModule 'Network/privateEndpoints.bicep' = {
  name: 'privateEndpointModule'
  params: {
    serviceName: eventGridModule.outputs.resourceName
    privateLinkServiceId: eventGridModule.outputs.subscriptionResourceId
    groupIds: [
      'domain'
    ]
    subnetName: 'integration'
    vnetResourceId: vnetSubscriptionResourceId
    internalHostName: hostname
  }
}

module privateEndpointARecordModule 'Network/privateDnsZones/A.bicep' = {
  name: 'privateEndpointARecordModule'
  scope: resourceGroup(networkingResourceGroupName)
  params: {
    privateDnsZone: internalDomainName
    hostnames: [
      {
        name: host
        ipAddress: privateEndpointModule.outputs.ipAddress
      }
    ]
  }
}
