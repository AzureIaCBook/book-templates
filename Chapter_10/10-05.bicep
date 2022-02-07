var subnetName = 'subnetName'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'exampleVirtualNetwork'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

module vm1Deployment 'br:BicepRegistryDemoUniqueName.azurecr.io/bicep/modules/vm:v1' = {
  name: 'vm1Deployment'
  params: {
    subnetName: subnetName
    virtualMachineIpAddress: '10.0.0.5'
    virtualMachineName: 'vm1'
    virtualMachinePassword: 'dontputpasswordsinbooks'
    virtualMachineSize: 'Standard_B2s'
    virtualMachineUsername: 'bicepadmin'
    virtualNetworkName: virtualNetwork.name
  }
}
