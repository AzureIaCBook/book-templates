var virtualNetworkName = 'workloadvnet'
var subnetName = 'workloadsubnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
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

@secure()
param vmPassword string

var virtualMachineDetails = [
  {
    ipAddress: '10.0.0.10'
    name: 'VM1'
    sku: 'Standard_B2s'
  }
  {
    ipAddress: '10.0.0.11'
    name: 'VM2'
    sku: 'Standard_D4ds_v4'
  }
]

resource virtualMachines 'Microsoft.Resources/deployments@2021-01-01' = [for vm in virtualMachineDetails : {
  name: concat(vm.name, '-spec-deployment')
  properties: {
    mode: 'Incremental'
    templateLink: {
      id: '/subscriptions/1dad7d18-a6d1-40c2-a56f-7dfe89999e67/resourceGroups/TemplateSpecs/providers/Microsoft.Resources/templateSpecs/compliantWindows2019Vm/versions/12.0'
    }
    parameters: {
      virtualNetworkName: {
        value: virtualNetworkName
      }
      subnetName: {
        value: subnetName
      }
      virtualMachineIpAddress: {
        value: vm.ipAddress
      }
      virtualMachineName: {
        value: vm.name
      }
      virtualMachineSize: {
        value: vm.sku
      }
      virtualMachineUsername: {
        value: 'bicepadmin'
      }
      virtualMachinePassword: {
        value: vmPassword
      }
    }
  }
}]

var recoveryServicesVaultName = 'backupvault'

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2021-01-01' = {
  name: recoveryServicesVaultName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource protectedItems 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2016-06-01' = [for (vm, i) in virtualMachineDetails: {
  name: concat(recoveryServicesVaultName, '/Azure/iaasvmcontainer;iaasvmcontainerv2;', resourceGroup().name, ';', virtualMachineDetails[i].name, '/vm;iaasvmcontainerv2;', resourceGroup().name, ';', virtualMachineDetails[i].name)
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', recoveryServicesVaultName, 'DefaultPolicy')
    sourceResourceId: reference(virtualMachines[i].name).outputs.compliantWindows2019VirtualMachineId.value
  }
}]
