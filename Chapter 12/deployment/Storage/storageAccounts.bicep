param systemName string
param locationName string
param deploymentSlot string
param sku object = {
  name: 'Standard_GRS'
  tier: 'Standard'
}

var storageAccountName = toLower('${systemName}${locationName}${deploymentSlot}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: sku
}
