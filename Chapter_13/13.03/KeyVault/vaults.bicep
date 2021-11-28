param defaultResourceName string

var resourceName = '${defaultResourceName}-kv'

resource keyVaultResource 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    tenantId: subscription().tenantId
    enabledForTemplateDeployment: true
    accessPolicies: []
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

output keyVaultName string = keyVaultResource.name
