param applicationInsightsName string
param logAnalyticsWorkspaceName string
param location string

resource applicationInsightsResource 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: applicationInsightsName
  kind: 'web'
  location: location
  properties: {
    Application_Type: 'web'
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
        retentionInDays: 60
        workspaceCapping: {
            dailyQuotaGb: -1
        }
    }
}

output instrumentationKey string = applicationInsightsResource.properties.InstrumentationKey
