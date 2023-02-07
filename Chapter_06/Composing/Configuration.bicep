param keyVaultName string
param appConfigurationName string
param templateSettings object

module keyVaultModule '../Resources/Keyvault/KeyVault.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: keyVaultName
    location: templateSettings.location
  }
}

module appConfigurationModule '../Resources/AppConfiguration/AppConfiguration.bicep' = {
  name: 'appConfigurationModule'
  params: {
    appConfigurationName: appConfigurationName
    location: templateSettings.location
  }
}
