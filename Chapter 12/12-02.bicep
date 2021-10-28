targetScope = 'subscription'

param managementGroupName string

module allowedLocationsPolicyDefinition '12-01.bicep' = {
  name: 'allowedLocationsPolicyDefinition'
}

resource initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: managementGroupName
  properties: {
    description: 'Definition set for management group \'${managementGroupName}\''
    policyDefinitions: [
      {
        policyDefinitionId: allowedLocationsPolicyDefinition.outputs.policyDefinitionId
      }
    ]
  }
}
