targetScope = 'subscription'

param systemName string = 'tomatoe'

@allowed([
  'dev'
  'test'
  'acc'
  'prod'
])
param environmentName string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${systemName}-${environmentName}'
  location: deployment().location
}

module trafficManagerModule 'Network/trafficmanagerprofiles.bicep' = {
  name: 'trafficManagerModule'
  scope: resourceGroup
  params: {
    systemName: systemName
    environmentName: environmentName
  }
}
