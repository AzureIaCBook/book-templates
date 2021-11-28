targetScope = 'subscription'

@description('Name of the system to be deployed, max 6 characters to prevent too long names in Azure')
@maxLength(6)
param systemName string

@description('Abbreviation of the Azure Region deployed to')
@allowed([
  'weu'
])
param locationAbbreviation string = 'weu'

@allowed([
  'dev'
  'tst'
  'prd'
])
param environmentCode string

@description('Name of the resource group that contains the deploy-time Key Vault')
param deployTimeKeyVaultResourceGroup string

@description('Name of Deploy Time key vault')
param deployTimeKeyVaultName string

@description('Name of the certificate for the external FQDN')
param appGatewayExternalCertificateName string

@description('Name of the certificate for the internal FQDN')
param appGatewayInternalCertificateName string

@description('The internal domain name for VNet communication')
param internalDomainName string

@description('The external domain name (the domain name requests are sent to)')
param externalDomainName string

var resourceLocation = locationAbbreviation == 'weu' ? 'westeurope' : 'westeurope'
var resourceGroupNetworking = 'net'
var resourceGroupIntegration = 'int'

resource networkingRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: resourceLocation
  name: '${systemName}-${resourceGroupNetworking}-${locationAbbreviation}-${environmentCode}'
  tags: {
    Kind: resourceGroupNetworking
    CostCenter: systemName
  }
}

resource integrationRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: resourceLocation
  name: '${systemName}-${resourceGroupIntegration}-${locationAbbreviation}-${environmentCode}'
  tags: {
    Kind: resourceGroupIntegration
    CostCenter: systemName
  }
}

module networkingModule 'networking.bicep' = {
  name: 'networkingModule'
  scope: networkingRg
  params: {
    systemName: systemName
    environmentCode: environmentCode
    internalDomainName: internalDomainName
    externalDomainName: externalDomainName
    defaultResourceName: '${systemName}-net-${locationAbbreviation}-${environmentCode}'
    appGatewayExternalCertificateName: appGatewayExternalCertificateName
    appGatewayInternalCertificateName: appGatewayInternalCertificateName
    deployTimeKeyVaultName: deployTimeKeyVaultName
    deployTimeKeyVaultResourceGroup: deployTimeKeyVaultResourceGroup
  }
}

module integrationModule 'integration.bicep' = {
  name: 'integrationModule'
  scope: integrationRg
  params: {
    defaultResourceName: '${systemName}-int-${locationAbbreviation}-${environmentCode}'
    vnetSubscriptionResourceId: networkingModule.outputs.vnetSubscriptionResourceId
    internalDomainName: internalDomainName
    networkingResourceGroupName: networkingRg.name
  }
}
