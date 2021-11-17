param keyVaultName string
param appConfigurationName string
param templateSettings object

// The variable below is part of the translation from ARM to Bicep, but no longer needed
// as the switch from linked deploments to Bicep modules, makes staging the resource 
// templates unnecessary. It is left in for reference only.
var templateBasePath = '${templateSettings.storageAccountUrl}/${templateSettings.storageContainer}'

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
