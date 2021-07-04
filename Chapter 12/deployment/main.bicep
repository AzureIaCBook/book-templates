targetScope = 'subscription'

param systemName string = 'demodeploy'

@allowed([
  'dev'
  'test'
  'acc'
  'prod'
])
param environmentName string = 'prod'

@allowed([
  'eur' // West europe
  'us' // East US (1)
  'asi' // Easy Japan
])
param locationAbbriviation string = 'us'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${systemName}-${environmentName}-${locationAbbriviation}'
  location: location
}

module appServicePlanModule 'Web/serverfarms.bicep' = {
  name: 'appServicePlan'
  scope: resourceGroup
  params: {
    systemName: systemName
    environmentName: environmentName
    locationAbbriviation: locationAbbriviation
  }
}

module webApplicationModule 'Web/sites.bicep' = {
  dependsOn: [
    appServicePlanModule
  ]
  name: 'webApplication'
  scope: resourceGroup
  params: {
    systemName: systemName
    environmentName: environmentName
    locationAbbriviation: locationAbbriviation
    serverFarmId: appServicePlanModule.outputs.serverFarmId
  }
}
