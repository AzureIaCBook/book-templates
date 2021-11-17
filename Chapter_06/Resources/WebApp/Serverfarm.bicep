param name string
param sku object
param location string

resource myServerFarmResource 'Microsoft.Web/serverfarms@2015-08-01' = {
  name: name
  kind: 'linux'
  location: location
  sku: {
    name: sku.name
    capacity: sku.capacity
  }
  properties: {
    name: name
    workerSizeId: '1'
    reserved: true
    numberOfWorkers: 1
  }
}
