param env string
param sufix string
param keyVaultName string
param sqlSettings object
param storageAccountSettings array
param templateSettings object

var sqlServerName = 'sql-${sufix}-${env}'
var SqlDatabaseName = 'sql-${sufix}-${env}'

module storageAccountModules '../Resources/Storage/StorageAccountV2.bicep' = [for storageAccountSetting in storageAccountSettings: {
  name: 'storageAccountModule-${storageAccountSetting.name}'
  params: {
    storageAccount: storageAccountSetting
    env: env
    keyVaultName: keyVaultName
    location: templateSettings.location
  }
}]

module SqlServerModule '../Resources/Sql/SqlServer.bicep' = {
  name: 'sqlServerModule'
  params: {
    name: sqlServerName
    sqlServerUsername: sqlSettings.sqlServerUsername
    sqlServerPassword: sqlSettings.sqlServerPassword
    location: templateSettings.location
  }
}

module sqlDatabaseModule '../Resources/Sql/SqlServerDatabase.bicep' = {
  name: 'sqlDatabaseModule'
  dependsOn: [
    SqlServerModule
  ]
  params: {
    name: SqlDatabaseName
    databaseSettings: sqlSettings.database
    sqlServerName: sqlServerName
    location: templateSettings.location
  }
}
