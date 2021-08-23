param webAppName string
param appServicePlanName string
param linuxFxVersion string = 'DOTNETCORE|3.1'
param appSettings array
param location string

resource webAppResource 'Microsoft.Web/sites@2018-02-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: appSettings
      linuxFxVersion: linuxFxVersion
    }
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
  }
}
