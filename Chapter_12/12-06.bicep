targetScope = 'subscription'

resource auditNSGwithoutLogAnalyticsEnabled 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'AuditNSGwithoutLogAnalyticsEnabled'
  properties: {
    policyType: 'Custom'
    displayName: 'Log analytics should be enabled for Network Security Group'
    description: 'This policy requires Network Security Groups to have a diagnostic setting set that exports logs to a log analytics workspace.'
    metadata: {
      version: '1.0.0'
      category: 'Network Security'
    }
    mode: 'All'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Network/networkSecurityGroups'
      }
      then: {
        effect: 'auditIfNotExists'
        'details': {
          'type': 'Microsoft.Insights/diagnosticSettings'
          'existenceCondition': {
            'allof': [
              {
                'field': 'Microsoft.Insights/diagnosticSettings/metrics.enabled'
                'equals': 'True'
              }
              {
                'field': 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                'equals': 'True'
              }

              {
                'field': 'Microsoft.Insights/diagnosticSettings/workspaceId'
                'exists': 'True'
              }
            ]
          }
        }
      }
    }
  }
}
