param systemName string = 'demodeploy'

@allowed([
  'dev'
  'test'
  'acc'
  'prod'
])
param environmentName string = 'prod'

resource trafficManager 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: '${systemName}-${environmentName}'
  properties: {
    trafficRoutingMethod: 'Geographic'
    endpoints: [
      {
        name: 'eur'
        properties: {
          target: 'demodeploy-prod-eur-app.azurewebsites.net'
          weight: 1
          priority: 1
          endpointLocation: 'West Europe'
          geoMapping: [
            'GEO-EU'
          ]
        }
      }
      {
        name: 'asi'
        properties: {
          target: 'demodeploy-prod-asi-app.azurewebsites.net'
          weight: 1
          priority: 2
          endpointLocation: 'East Asia'
          geoMapping: [
            'GEO-AS'
            'GEO-AP'
            'GEO-ME'
          ]
        }
      }
      {
        name: 'global'
        properties: {
          target: 'demodeploy-prod-us-app.azurewebsites.net'
          weight: 1
          priority: 3
          endpointLocation: 'West US'
          geoMapping: [
            'WORLD'
          ]
        }
      }
    ]
  }
}
