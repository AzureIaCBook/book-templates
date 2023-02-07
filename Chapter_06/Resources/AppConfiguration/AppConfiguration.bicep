param appConfigurationName string
param skuName string = 'standard'
param location string

resource configurationStore 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: appConfigurationName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    encryption: {}
  }
}
