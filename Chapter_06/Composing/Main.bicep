param env string
param sufix string 
param appServicePlanSku object
param sqlSettings object
param storageAccountSettings array
param templateSettings object

var keyVaultName = 'kv-${sufix}-${env}'
var appConfigurationName = 'appconfig-${sufix}-${env}'

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
    sufix: sufix
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
    sufix: sufix
    keyVaultName: keyVaultName
    sqlSettings: sqlSettings
    storageAccountSettings: storageAccountSettings
    templateSettings: templateSettings
  }
}
