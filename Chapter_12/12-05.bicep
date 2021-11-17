targetScope = 'subscription'

resource appendIpToStorageFirewall 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'appendIpToStorageFirewall'
  properties: {
    policyType: 'Custom'
    displayName: 'Add an IP address to the storage accounts firewall'
    description: 'Add an IP address to the storage accounts firewall'
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
        effect: 'append'
        details: [
          {
            field: 'Microsoft.Storage/storageAccounts/networkAcls.ipRules[*]'
            value: {
              value: '40.40.40.40'
              action: 'Allow'
            }
          }
        ]
      }
    }
  }
}
