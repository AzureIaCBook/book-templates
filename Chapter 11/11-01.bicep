targetScope = 'subscription'

resource allowedLocationsPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'allowedLocations_deny'
  properties: {
    displayName: 'Allowed locations'
    description: 'The list of locations that can be specified when deploying resources.'
    mode: 'Indexed'
    policyType: 'Custom'
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed locations'
          description: 'The list of locations that can be specified when deploying resources.'
          strongType: 'location'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'location'
            notIn: '[parameters(\'listOfAllowedLocations\')]'
          }
          {
            field: 'location'
            notEquals: 'global'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

output policyDefinitionId string = allowedLocationsPolicyDefinition.id
