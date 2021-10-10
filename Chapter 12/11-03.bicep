targetScope = 'managementGroup'

param managementGroupName string
param policySetName string

var managementGroupScope = '/providers/Microsoft.Management/managementGroups/${managementGroupName}'

resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: managementGroupName
  location: 'westeurope'
  properties:{
    description: 'The assignment of the policy set definition \'${policySetName}\' to management group \'${managementGroupName}\''
    policyDefinitionId: '${managementGroupScope}/providers/Microsoft.Authorization/policySetDefinitions/${policySetName}'  
  }
}
