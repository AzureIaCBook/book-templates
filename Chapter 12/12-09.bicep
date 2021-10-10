targetScope = 'subscription'

module allowedLocationsPolicyDefinition './12-01.bicep' = {
  name: 'allowedLocationsPolicyDefinition'
  scope: subscription()
}

resource initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'MyCustomInitiative'
  properties: {
    description: 'This policy definition set comprises the scoped policies for subscription \'${subscription().displayName}\''
    policyDefinitions: [
      {
        policyDefinitionId: allowedLocationsPolicyDefinition.outputs.policyDefinitionId
        parameters: {
          listOfAllowedLocations: {
            value: [
              'northeurope'
              'westeurope'
            ]
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53'
      }
    ]
  }
}
