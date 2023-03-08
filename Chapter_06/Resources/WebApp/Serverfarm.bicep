param name string
param sku object
param location string

resource myServerFarmResource 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  kind: 'linux'
  location: location
  sku: {
    name: sku.name
    capacity: sku.capacity
  }
  properties: {
    reserved: true    
  }
}
