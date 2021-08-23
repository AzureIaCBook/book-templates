param env string
param appServicePlanSku object
param sqlSettings object
param storageAccountSettings array
param templateSettings object

var keyVaultName = 'kv-bookdemo-${env}'
var appConfigurationName = 'appconfig-bookdemo-${env}'

module configurationModule './Configuration.bicep' = {
  name: 'configurationModule'
  params: {
    keyVaultName: keyVaultName
    appConfigurationName: appConfigurationName
    templateSettings: templateSettings
  }
}

module apiModule './Api.bicep' = {
  name: 'apiModule'
  dependsOn: [
    configurationModule
  ]
  params: {
    env: env
    appServicePlanSku: appServicePlanSku
    keyVaultName: keyVaultName
    appConfigurationName: appConfigurationName
    templateSettings: templateSettings
  }
}

module storageModule './Storage.bicep' = {
  name: 'storageModule'
  dependsOn: [
    configurationModule
  ]
  params: {
    env: env
    keyVaultName: keyVaultName
    sqlSettings: sqlSettings
    storageAccountSettings: storageAccountSettings
    templateSettings: templateSettings
  }
}
