param vnetName string
param addressPrefixes array
param subnetName string
param subnetAddressPrefix string
param location string = '${resourceGroup().location}'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  location: location
  name: vnetName
  properties:{
    addressSpace:{
      addressPrefixes:addressPrefixes 
    }
    subnets:[
      {
        name:subnetName
        properties:{
          addressPrefix: subnetAddressPrefix          
        }
      }
    ]    
  }
}
