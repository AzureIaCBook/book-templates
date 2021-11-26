targetScope = 'subscription'

resource logsResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'logs'
  location: 'westeurope'
}

module logsResourcesDeployment '13-03-02-resourceGroup.bicep' = {
  name: 'logsResources'
  scope: logsResourceGroup
}
