targetScope = 'resourceGroup'

param appName string
param subnetResourceId string
param location string = resourceGroup().location

param restrictAccess bool
param restrictAccessFromSubnetId string = ''

resource hosting 'Microsoft.Web/serverfarms@2019-08-01' = {
  name: 'hosting-${appName}'
  location: location
  sku: {
    name: 'S1'
  }
}

resource app 'Microsoft.Web/sites@2018-11-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: hosting.id
  }
}

resource netConfig 'Microsoft.Web/sites/networkConfig@2019-08-01' = {
  name: '${appName}/virtualNetwork'
  dependsOn: [
    app
  ]
  properties: {
    subnetResourceId: subnetResourceId
    swiftSupported: true
  }
}

resource config 'Microsoft.Web/sites/config@2020-12-01' = if (restrictAccess) {
  name: '${appName}/web'
  dependsOn: [
    app
  ]
  properties: {
    ipSecurityRestrictions: [
      {
        vnetSubnetResourceId: restrictAccessFromSubnetId
        action: 'Allow'
        priority: 100
        name: 'frontend'
      }
      {
        ipAddress: 'Any'
        action: 'Deny'
        priority: 2147483647
        name: 'Deny all'
        description: 'Deny all access'
      }
    ]
  }
}
