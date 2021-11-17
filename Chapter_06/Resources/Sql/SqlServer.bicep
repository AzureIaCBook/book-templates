param name string
param sqlServerUsername string
@secure()
param sqlServerPassword string
param location string

resource mySqlServerResource 'Microsoft.Sql/servers@2015-05-01-preview' = {
  name: name
  location: location
  properties: {
    administratorLogin: sqlServerUsername
    administratorLoginPassword: sqlServerPassword
    version: '12.0'
  }

  resource firewallRuleResource 'firewallRules' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }
}
