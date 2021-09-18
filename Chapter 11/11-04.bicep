targetScope = 'subscription'

resource denyAnySqlServerAccessFromInternet 'Microsoft.Authorization/policyDefinitions@2019-09-01' = {
  name: 'denyAnySqlServerAccessFromInternet'
  properties: {
    displayName: 'Deny Any SQL Server Access from the Internet'
    policyType: 'Custom'
    mode: 'All'
    description: 'Deny Any SQL Server Access from the Internet ip address'
    metadata: {
      version: '1.0.0'
      category: 'SQL Server'
    }
    parameters: {
      effect: {
        type: 'String'
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Deny'
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Sql/servers'
          }
          {
            field: 'Microsoft.Sql/servers/publicNetworkAccess'
            notEquals: 'Disabled'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
