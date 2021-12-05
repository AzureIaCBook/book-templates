param defaultResourceName string

@allowed([
  'dev'
  'tst'
  'prd'
])
param environmentCode string

var resourceName = '${defaultResourceName}-fwp'
var firewallTier = environmentCode == 'prod' ? 'Standard' : 'Standard'

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-03-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    sku: {
      tier: firewallTier
    }
    threatIntelWhitelist: {
      fqdns: []
      ipAddresses: []
    }
  }
}

output subscriptionResourceId string = firewallPolicy.id
