targetScope = 'subscription'

param systemName string
param environmentName string
@allowed([
  'we' // West europe
  'us' // East US (1)
  'asi' // East Japan
])
param locationAbbriviation string

resource targetResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: deployment().location
  name: '${systemName}-${environmentName}-${locationAbbriviation}'
}

module appServicePlanModule 'Web/serverfarms.bicep' = {
  name: 'appServicePlan'
  scope: targetResourceGroup
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
  scope: targetResourceGroup
  params: {
    systemName: systemName
    environmentName: environmentName
    locationAbbriviation: locationAbbriviation
    serverFarmId: appServicePlanModule.outputs.serverFarmId
  }
}
