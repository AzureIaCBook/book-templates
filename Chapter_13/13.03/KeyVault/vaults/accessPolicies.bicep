param keyVaultName string
param objectId string

resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: objectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'list'
            'get'
          ]
          certificates: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}
