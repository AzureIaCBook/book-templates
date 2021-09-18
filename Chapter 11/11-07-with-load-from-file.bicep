targetScope = 'subscription'

resource enforceAscDefenderStoragePolicyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'ascDefenderStorage_deployIfNotExists'
  properties: {
    displayName: 'Enforce Asc Defender for Storage'
    description: 'Enforces Azure Security Center Defender for Storage on subscriptions.'
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/Subscriptions'
          }
        ]
      }
      then: {
        effect: 'DeployIfNotExists'
        details: {
          type: 'Microsoft.Security/pricings'
          name: 'StorageAccounts'
          deploymentScope: 'Subscription'
          existenceScope: 'Subscription'
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
          ]
          existenceCondition: {
            field: 'Microsoft.Security/pricings/pricingTier'
            equals: 'Standard'
          }
          deployment: {
            location: 'westeurope'
            properties: {
              mode: 'Incremental'
              template: loadTextContent('securityCenterPricing.json')
            }
          }
        }
      }
    }
  }
}
