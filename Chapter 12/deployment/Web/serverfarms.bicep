param systemName string

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
param locationAbbriviation string

var serverFarmName = '${systemName}-${environmentName}-${locationAbbriviation}-plan'

resource serverFarm 'Microsoft.Web/serverfarms@2021-01-01' = {
  name: serverFarmName
  location: resourceGroup().location
  kind: 'app'
  sku: {
    name: 'B1'
    capacity: 1
  }
}

output serverFarmId string = serverFarm.id
