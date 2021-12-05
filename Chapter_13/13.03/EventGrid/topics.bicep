param defaultResourceName string

var resourceName = '${defaultResourceName}-grid'

resource eventGridTopic 'Microsoft.EventGrid/topics@2021-06-01-preview' = {
  name: resourceName
  location: resourceGroup().location
  kind: 'Azure'
  sku: {
    name: 'Basic'
  }
  properties: {
    inputSchema: 'EventGridSchema'
    publicNetworkAccess: 'Disabled'
    disableLocalAuth: false
  }
}

output resourceName string = resourceName
output subscriptionResourceId string = eventGridTopic.id // resourceId(subscription().id, resourceGroup().name, eventGridTopic.type, eventGridTopic.name)
