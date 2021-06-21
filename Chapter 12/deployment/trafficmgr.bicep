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
  location: 'global'
  properties: {
    trafficRoutingMethod: 'Geographic'
    dnsConfig: {
      relativeName: '${systemName}-${environmentName}'
      ttl: 60
    }
    monitorConfig: {
      profileMonitorStatus: 'Online'
      protocol: 'HTTPS'
      path: '/'
      port: 443
      intervalInSeconds: 30
      toleratedNumberOfFailures: 3
      timeoutInSeconds: 10
    }
    endpoints: [
      {
        name: 'eur'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
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
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
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
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
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
