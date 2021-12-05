targetScope = 'tenant'

resource yourCompanyMG 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'YourCompany'
  scope: tenant()
  properties: {
    displayName: 'Your Company'

  }
}

resource FoundationMG 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'Foundation'
  scope: tenant()
  properties: {
    displayName: 'Foundation'
    details: {
      parent: {
        id: yourCompanyMG.id
      }
    }
  }
}

resource ManagedMG 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'Managed'
  scope: tenant()
  properties: {
    displayName: 'Managed'
    details: {
      parent: {
        id: yourCompanyMG.id
      }
    }
  }
}

resource UnmanagedMG 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'Unmanaged'
  scope: tenant()
  properties: {
    displayName: 'Unmanaged'
    details: {
      parent: {
        id: yourCompanyMG.id
      }
    }
  }
}

module ManagedMGPolicyAssignments '13-03-01.bicep' = {
  name: 'ManagedMGPolicyAssignmentsDeployment'
  scope: ManagedMG
  params: {
    managementGroupName: ManagedMG.name
  }
}

module ManagementSubscription '13-03-02.bicep' = {
  name: 'ManagementSubscriptionDeployment'
  scope: tenant()
  params: {
    managementGroupId: FoundationMG.id
  }
}
