param defaultResourceName string

var resourceName = '${defaultResourceName}-uaid'

resource userAssignedManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: resourceName
  location: resourceGroup().location
}

output id string = userAssignedManagedIdentity.id
output principalId string = userAssignedManagedIdentity.properties.principalId
output name string = userAssignedManagedIdentity.name
