targetScope = 'subscription'

resource setAllowBlobPublicAccessToFalse 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'setAllowBlobPublicAccessToFalse'
  properties: {
    policyType: 'Custom'
    displayName: 'Set setAllowBlobPublicAccessToFalse to false on a Storage Account'
    description: 'Set setAllowBlobPublicAccessToFalse to false on a Storage Account when the API version is greather than 2019-04-01'
    metadata: {
      version: '1.0.0'
      category: 'Network Security'
    }
    mode: 'All'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Storage/storageAccounts'
      }
      then: {
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab'
          ]
          conflictEffect: 'audit'
          operations: [
            {
              condition: '[greaterOrEquals(requestContext().apiVersion, \'2019-04-01\')]'
              operation: 'addOrReplace'
              field: 'Microsoft.Storage/storageAccounts/allowBlobPublicAccess'
              value: false
            }
          ]
        }
      }
    }
  }
}
