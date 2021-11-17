targetScope = 'subscription'

resource privateEndpointShouldBeEnabledPolicyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'privateEndpointShouldBeEnabledPolicyExemption'
  properties: {
    displayName: 'ASC-Private endpoint should be enabled'
    policyAssignmentId: '${subscription().id}/providers/Microsoft.Authorization/policyAssignments/SecurityCenterBuiltIn'
    policyDefinitionReferenceIds: [ 
      'privateEndpointShouldBeEnabledForMysqlServersMonitoringEffect'
      'storageAccountShouldUseAPrivateLinkConnectionMonitoringEffect'
      'privateEndpointShouldBeConfiguredForKeyVaultMonitoringEffect'
    ]
    exemptionCategory: 'Waiver'
    expiresOn: '01/01/2022 12:00'
    description: 'Using firewall rules for now.'
  }
}
