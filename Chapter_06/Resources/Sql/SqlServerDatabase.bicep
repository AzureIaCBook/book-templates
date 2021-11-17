param name string
param databaseSettings object
param sqlServerName string
param location string

resource databaseResource 'Microsoft.Sql/servers/databases@2017-10-01-preview' = {
  name: '${sqlServerName}/${name}'
  location: location
  sku: {
    name: databaseSettings.sku.name
    tier: databaseSettings.sku.tier
    capacity: databaseSettings.sku.capacity
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: databaseSettings.maxSizeBytes
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
  }
}
