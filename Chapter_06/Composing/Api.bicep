param env string
param appServicePlanSku object
param keyVaultName string
param appConfigurationName string
param templateSettings object

var logAnalyticsWorkspaceName = 'log-bookdemo-${env}'
var appInsightsName = 'appi-bookdemo-${env}'
var webAppName = 'app-bookdemo-${env}'
var webAppNamePlan = 'plan-bookdemo-${env}'
var keyVaultSecretReaderRoleId = '4633458b-17de-408a-b874-0445c86b69e6' // RBAC Role: Key Vault Secrets User
var appConfigurationReaderRoleId = '516239f1-63e1-4d78-a4de-a74fb236a071' // RBAC Role: App Configuration Data Reader

// The variable below is part of the translation from ARM to Bicep, but no longer needed
// as the switch from linked deploments to Bicep modules, makes staging the resource 
// templates unnecessary. It is left in for reference only.
var templateBasePath = '${templateSettings.storageAccountUrl}/${templateSettings.storageContainer}'


module applicationInsightsModule '../Resources/Insights/ApplicationInsights.bicep' = {
  name: 'applicationInsightsModule'
  params: {
    applicationInsightsName: appInsightsName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: templateSettings.location
  }
}

module serverFarmModule '../Resources/WebApp/Serverfarm.bicep' = {
  name: 'serverFarmModule'
  params: {
    name: webAppNamePlan
    sku: appServicePlanSku
    location: templateSettings.location
  }
}

module webAppModule '../Resources/WebApp/WebApp.bicep' = {
  name: 'webAppModule'
  params: {
    webAppName: webAppName
    appServicePlanName: webAppNamePlan
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: reference(resourceId('Microsoft.Insights/components', appInsightsName), '2014-04-01').InstrumentationKey
      }
    ]
    location: templateSettings.location
  }
  dependsOn: [
    serverFarmModule
    applicationInsightsModule
  ]
}

resource SecretReaderResource 'Microsoft.KeyVault/vaults/providers/roleAssignments@2018-01-01-preview' = {
  name: '${keyVaultName}/Microsoft.Authorization/${guid(webAppName, keyVaultSecretReaderRoleId)}'
  dependsOn: [
    webAppModule
  ]
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roledefinitions/${keyVaultSecretReaderRoleId}'
    principalId: reference(resourceId('Microsoft.Web/sites', webAppName), '2019-08-01', 'full').identity.principalId
  }
}

resource ConfigurationReaderResource 'Microsoft.AppConfiguration/configurationstores/providers/roleAssignments@2018-01-01-preview' = {
  name: '${appConfigurationName}/Microsoft.Authorization/${guid(webAppName, appConfigurationReaderRoleId)}'
  dependsOn: [
    webAppModule
  ]
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roledefinitions/${appConfigurationReaderRoleId}'
    principalId: reference(resourceId('Microsoft.Web/sites', webAppName), '2019-08-01', 'full').identity.principalId
  }
}
