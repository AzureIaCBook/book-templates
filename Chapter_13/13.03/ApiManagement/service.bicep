param defaultResourceName string
@allowed([
  'dev'
  'tst'
  'prd'
])
param environmentCode string
param vnetResourceId string
param subnetName string = 'apim'
param internalDomainName string
param userAssignedManagedIdentityName string
param deployTimeKeyVaultName string
param appGatewayInternalCertificateName string

var resourceName = '${defaultResourceName}-apim'
var apimSkuName = environmentCode == 'prd' ? 'Premium' : 'Developer'
var proxyHostname = 'gateway.${internalDomainName}'
var managementHostname = 'management.${internalDomainName}'
var portalHostname = 'portal.${internalDomainName}'
var devPortalHostname = 'dev-portal.${internalDomainName}'

resource existing_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: userAssignedManagedIdentityName
}

resource apim 'Microsoft.ApiManagement/service@2021-04-01-preview' = {
  location: resourceGroup().location
  name: resourceName
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${existing_identity.id}': {}
    }
  }
  sku: {
    name: apimSkuName
    capacity: 1
  }
  properties: {
    publisherName: 'SnelStart B.V.'
    publisherEmail: 'admin@snelstart.nl'
    virtualNetworkType: 'Internal'
    virtualNetworkConfiguration: {
      subnetResourceId: '${vnetResourceId}/subnets/${subnetName}'
    }
    hostnameConfigurations: [
      {
        type: 'Proxy'
        hostName: proxyHostname
        keyVaultId: 'https://${deployTimeKeyVaultName}${environment().suffixes.keyvaultDns}/secrets/${appGatewayInternalCertificateName}'
        identityClientId: existing_identity.properties.clientId
        negotiateClientCertificate: false
        defaultSslBinding: true
      }
      {
        type: 'Management'
        hostName: managementHostname
        keyVaultId: 'https://${deployTimeKeyVaultName}${environment().suffixes.keyvaultDns}/secrets/${appGatewayInternalCertificateName}'
        identityClientId: existing_identity.properties.clientId
        negotiateClientCertificate: false
      }
      {
        type: 'Portal'
        hostName: portalHostname
        keyVaultId: 'https://${deployTimeKeyVaultName}${environment().suffixes.keyvaultDns}/secrets/${appGatewayInternalCertificateName}'
        identityClientId: existing_identity.properties.clientId
        negotiateClientCertificate: false
      }
      {
        type: 'DeveloperPortal'
        hostName: devPortalHostname
        keyVaultId: 'https://${deployTimeKeyVaultName}${environment().suffixes.keyvaultDns}/secrets/${appGatewayInternalCertificateName}'
        identityClientId: existing_identity.properties.clientId
        negotiateClientCertificate: false
      }
    ]
  }
}

output apiManagementId string = apim.id
output apiManagementPrivateIpAddresses array = apim.properties.privateIPAddresses

output domainNames array = [
  {
    name: 'gateway'
    ipAddress: apim.properties.privateIPAddresses[0]
  }
  {
    name: 'management'
    ipAddress: apim.properties.privateIPAddresses[0]
  }
  {
    name: 'portal'
    ipAddress: apim.properties.privateIPAddresses[0]
  }
  {
    name: 'dev-portal'
    ipAddress: apim.properties.privateIPAddresses[0]
  }
]
