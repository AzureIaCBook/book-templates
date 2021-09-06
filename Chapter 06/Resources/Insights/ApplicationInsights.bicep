param applicationInsightsName string
param logAnalyticsWorkspaceName string
param location string

resource applicationInsightsResource 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: applicationInsightsName
  kind: 'web'
  dependsOn: [
    omsWorkspaceResource
  ]
  location: location
  properties: {
    applicationId: applicationInsightsName
    WorkspaceResourceId: omsWorkspaceResource.id
  }
}

resource omsWorkspaceResource 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
    name: logAnalyticsWorkspaceName
    location: location
    properties: {
        sku: {
            name: 'PerGB2018'
        }
        retentionInDays: 30
        workspaceCapping: {
            dailyQuotaGb: -1
        }
    }
}
