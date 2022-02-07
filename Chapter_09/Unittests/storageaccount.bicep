param storageAccountName string
param location string

@allowed([
  'Premium'
  'Standard'
])
param sku string

var premiumSku = {
  name: 'Premium_LRS'
}

var standardSku = {
  name: 'Standard_LRS'
}

var skuCalculated = sku == 'Premium' ? premiumSku : standardSku

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  sku: skuCalculated
  kind: 'StorageV2'
}
