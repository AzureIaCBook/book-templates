param defaultResourceName string

var resourceName = '${defaultResourceName}-logws'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output logAnalyticsWorkspaceId string = logAnalytics.id
