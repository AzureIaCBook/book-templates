targetScope = 'managementGroup'

param managementGroupName string

var managementGroupScope = '/providers/Microsoft.Management/managementGroups/${managementGroupName}'
var builtInIso27001InitiativeId = '89c6cddc-1c73-4ac1-b19c-54d1a15a42f2'

resource iso27001assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: managementGroupName
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties:{
    description: 'The assignment of the ISO27001 initiative'
    policyDefinitionId: '${managementGroupScope}/providers/Microsoft.Authorization/policySetDefinitions/${builtInIso27001InitiativeId}'  
  }
}
