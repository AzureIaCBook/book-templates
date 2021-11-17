targetScope = 'subscription'

param rg1Name string = 'rg-firstvnet'
param rg1Location string = 'westeurope'
param rg2Name string = 'rg-secondvnet'
param rg2Location string = 'westeurope'
param vnet1Name string = 'vnet-first'
param vnet2Name string = 'vnet-second'

resource rg1 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rg1Name
  location: rg1Location
}

resource rg2 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rg2Name
  location: rg2Location
}

module vnet1 'vnet.bicep' = {
  name: 'vnet1'
  scope: resourceGroup(rg1.name)
  params: {
    vnetName: vnet1Name
    addressPrefixes: [
      '10.1.1.0/24'
    ]
    subnetName: 'd-sne${vnet1Name}-01'
    subnetAddressPrefix: '10.1.1.0/24'
  }
}

module vnet2 'vnet.bicep' = {
  name: 'vnet2'
  scope: resourceGroup(rg2.name)
  params: {
    vnetName: vnet2Name
    addressPrefixes: [
      '10.2.1.0/24'
    ]
    subnetName: 'd-sne${vnet2Name}-01'
    subnetAddressPrefix: '10.2.1.0/24'
  }
}

module peering1 'vnet-peering.bicep' = {
  name: 'peering1'
  scope: resourceGroup(rg1.name)
  dependsOn: [
    vnet1
    vnet2
  ]
  params: {
    localVnetName: vnet1Name
    remoteVnetName: vnet2Name
    remoteVnetRg: rg2Name
  }
}

module peering2 'vnet-peering.bicep' = {
  name: 'peering2'
  scope: resourceGroup(rg2.name)
  dependsOn: [
    vnet2
    vnet1
  ]
  params: {
    localVnetName: vnet2Name
    remoteVnetName: vnet1Name
    remoteVnetRg: rg1Name
  }
}
