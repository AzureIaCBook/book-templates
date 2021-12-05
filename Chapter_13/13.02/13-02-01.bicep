targetScope = 'subscription'

param maximumBudget int

resource defaultBudget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: 'default-budget'
  properties: {
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: '2021-11-01'
    }
    category: 'Cost'
    amount: maximumBudget
    notifications: {
      Actual_Over_80_Percent: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 80
        thresholdType: 'Actual'
        contactEmails: [
          'henry@azurespecialist.nl'
        ]
      }
    }
  }
}
