param virtualMachineName string
@allowed([
  'Standard_B2s'
  'Standard_D4ds_v4'
])
param virtualMachineSize string
param virtualMachineUsername string
@secure()
param virtualMachinePassword string
param virtualNetworkName string
param subnetName string
param virtualMachineIpAddress string

output compliantWindows2019VirtualMachineId string = compliantWindows2019VirtualMachine.id

resource compliantWindows2019VirtualMachine 'Microsoft.Compute/virtualMachines@2020-12-01'  = {
  name: virtualMachineName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    compliantNetworkCard
  ]
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: virtualMachineName
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: virtualMachineUsername
      adminPassword: virtualMachinePassword
      windowsConfiguration: {
        timeZone: 'Central Europe Standard Time'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: compliantNetworkCard.id
        }
      ]
    }
  }
}

resource compliantNetworkCard 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: virtualMachineName
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'IPConfiguration-NICE-VM1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: virtualMachineIpAddress
          subnet: {
            id: resourceId('Networking.WestEurope.Spoke', 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
}

resource azureAADLogin 'Microsoft.Compute/virtualMachines/extensions@2015-06-15' = {
  name: '${virtualMachineName}/azureAADLogin'
  location: resourceGroup().location
  dependsOn: [
    compliantWindows2019VirtualMachine
  ]
  properties: {
    type: 'AADLoginForWindows'
    publisher: 'Microsoft.Azure.ActiveDirectory'
    typeHandlerVersion: '0.4'
    autoUpgradeMinorVersion: true
  }
}

resource AzurePolicyforWindows 'Microsoft.Compute/virtualMachines/extensions@2015-06-15' = {
  name: '${virtualMachineName}/AzurePolicyforWindows'
  location: resourceGroup().location
  dependsOn: [
    compliantWindows2019VirtualMachine
  ]
  properties: {
    type: 'ConfigurationforWindows'
    publisher: 'Microsoft.GuestConfiguration'
    typeHandlerVersion: '1.1'
    autoUpgradeMinorVersion: true
  }
}
