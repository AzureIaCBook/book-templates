param storageAccountName string
param location string

@allowed([
  'Premium'
  'Standard'
])
param sku string

var premiumSku = {
  name: 'Premium_LRS'
  tier: 'Premium'
}

var standardSku = {
  name: 'Standard_LRS'
  tier: 'Standard'
}

var skuCalculated = sku == 'Premium' ? premiumSku : standardSku

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  sku: skuCalculated
  kind: 'StorageV2'
}
