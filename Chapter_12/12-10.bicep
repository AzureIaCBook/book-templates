targetScope = 'subscription'

param policySetName string

resource myFirstAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'MyFirstAssignment'
  location: 'westeurope'
  identity:{
    type: 'SystemAssigned'
  }
  properties:{
    policyDefinitionId: '${subscription().id}/providers/Microsoft.Authorization/policySetDefinitions/${policySetName}'    
  }
}
