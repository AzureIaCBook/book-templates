targetScope = 'subscription'

param logAnalyticsWorkspaceId string

resource activityLogsConfiguration 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'activityLogsToLogAnalytics'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'Administrative'
        enabled: true
      }
      {
        category: 'Security'
        enabled: true
      }
      {
        category: 'Policy'
        enabled: true
      }
      {
        category: 'Alert'
        enabled: true
      }
    ]
  }
}
