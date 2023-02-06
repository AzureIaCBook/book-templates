param appConfigurationName string
param skuName string = 'standard'
param location string

resource configurationStore 'Microsoft.AppConfiguration/configurationStores@2019-11-01-preview' = {
  name: appConfigurationName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    encryption: {}
  }
}
