targetScope = 'subscription'

module budgetDeployment '13-02-01.bicep' = {
  name: 'budget'
  params: {
    maximumBudget: 1000
  }
}

module securityCenterConfigurationDeployment '13-02-02.bicep' = {
  name: 'securityCenterConfiguration'
}

module resourceGroupDeployment '13-02-03.bicep' = {
  name: 'resourceGroup'
}
