resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'logs'
  location: resourceGroup().location
  properties: {
    retentionInDays: 365
    enableLogAccessUsingOnlyResourcePermissions: true
  }
}
