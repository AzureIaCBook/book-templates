targetScope = 'subscription'

param managementGroupName string

module allowedLocationsPolicyDefinition '11-01.bicep' = {
  name: 'allowedLocationsPolicyDefinition'
}

resource initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: managementGroupName
  properties: {
    description: 'This policy definition set comprises the scoped policies for management group \'${managementGroupName}\''
    policyDefinitions: [
      {
        policyDefinitionId: '/providers/Microsoft.Management/managementGroups/${managementGroupName}/providers/${allowedLocationsPolicyDefinition.outputs.policyDefinitionId}'
      }
    ]
  }
}
