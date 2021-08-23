param storageAccount object
param env string
param location string

resource myStorageAccountResource 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: 'stor${storageAccount.name}${env}'
  sku: {
    name: storageAccount.sku.name
    tier: storageAccount.sku.tier
  }
  kind: 'StorageV2'
  location: location
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Cool'
  }
}
