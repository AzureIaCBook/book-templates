targetScope = 'subscription'

var enableSecurityCenterFor = [
  'KeyVaults'
  'VirtualMachines'
]

resource securityCenterPricing 'Microsoft.Security/pricings@2018-06-01' = [for name in enableSecurityCenterFor: {
  name: name
  properties: {
    pricingTier: 'Standard'
  }
}]

resource securityCenterContacts 'Microsoft.Security/securityContacts@2020-01-01-preview' = {
  name: 'default'
  properties: {
    emails: 'henry@does-not-exist.com'
    alertNotifications: {
      state: 'On'
      minimalSeverity: 'High'
    }
    notificationsByRole: {
      state: 'Off'
      roles: [
      ]
    }
  }
}
