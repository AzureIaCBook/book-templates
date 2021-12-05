targetScope = 'subscription'

var resourceGroupName = 'storageLayer'
resource storageLayerRef 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: 'westeurope'
}

module resourceGroupRBAC '13-02-03-roleAssignment.bicep' = {
  name: 'resourceGroupRBACDeployment'
  scope: resourceGroup(resourceGroupName)
}
