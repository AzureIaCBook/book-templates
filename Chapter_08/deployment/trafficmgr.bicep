targetScope = 'subscription'

param systemName string
param environmentName string
@allowed([
  'we' // West europe
  'us' // East US (1)
  'asi' // East Japan
])
param locationAbbriviation string

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
