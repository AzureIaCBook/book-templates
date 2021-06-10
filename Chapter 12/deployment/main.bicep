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

module appServicePlanModule 'Web/serverfarms.bicep' = {
  name: 'appServicePlan'
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
  params: {
    systemName: systemName
    environmentName: environmentName
    locationAbbriviation: locationAbbriviation
    serverFarmId: appServicePlanModule.outputs.serverFarmId
  }
}
