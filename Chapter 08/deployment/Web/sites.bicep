param systemName string
param environmentName string
@allowed([
  'we' // West europe
  'us' // East US (1)
  'asi' // East Japan
])
param locationAbbriviation string

param serverFarmId string

var webAppName = '${systemName}-${environmentName}-${locationAbbriviation}-app'

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: webAppName
  location: resourceGroup().location
  kind: 'app'
  properties: {
    serverFarmId: serverFarmId
  }
}
