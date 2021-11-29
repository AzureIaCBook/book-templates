/*
  This is the Networking template, it describes all resources deployed to the resource group
  {systemName}-net-{region}-{environmentCode}
*/

param systemName string
@allowed([
  'dev'
  'tst'
  'prd'
])
param environmentCode string
param defaultResourceName string
param internalDomainName string
param externalDomainName string

param deployTimeKeyVaultName string
param deployTimeKeyVaultResourceGroup string

param appGatewayExternalCertificateName string
param appGatewayInternalCertificateName string

// Not the address space cannot be changed once a VNet was created
// You may need to change the address space to fit your needs
var vnetAddressPrefixes = [
  '10.0.0.0/16'
]

// Same for subnets, /24 means 251 available addresses, you
// may want to change the address space for your subnets
// depending on your needs.
var subnets = [
  {
    name: 'gateway'
    prefix: '10.0.0.0/24'
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: []
  }
  {
    name: 'apim'
    prefix: '10.0.1.0/24'
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: []
  }
  {
    name: 'integration'
    prefix: '10.0.2.0/24'
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: []
  }
  {
    name: 'services'
    prefix: '10.0.3.0/24'
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: []
  }
]

resource deployTimeKeyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: deployTimeKeyVaultName
  scope: resourceGroup(deployTimeKeyVaultResourceGroup)
}

module userAssignedIdentityModule 'ManagedIdentity/userAssignedIdentities.bicep' = {
  name: 'userAssignedIdentityModule'
  params: {
    defaultResourceName: defaultResourceName
  }
}

module keyVaultAccessPoliciesForUaidModule 'KeyVault/vaults/accessPolicies.bicep' = {
  name: 'keyVaultAccessPoliciesForUaidModule'
  scope: resourceGroup(deployTimeKeyVaultResourceGroup)
  params: {
    keyVaultName: deployTimeKeyVault.name
    objectId: userAssignedIdentityModule.outputs.principalId
  }
}

module publicIpAddressModule 'Network/publicIpAddresses.bicep' = {
  name: 'publicIpAddressModule'
  params: {
    defaultResourceName: defaultResourceName
  }
}

module vNetModule 'Network/virtualNetworks.bicep' = {
  name: 'vNetModule'
  params: {
    defaultResourceName: defaultResourceName
    addressPrefixes: vnetAddressPrefixes
    subnets: subnets
  }
}

module privateDnsZoneModule 'Network/privateDnsZones.bicep' = {
  name: 'privateDnsZoneModule'
  params: {
    privateDnsZoneName: internalDomainName
  }
}

module virtualNetworkLinkModule 'Network/virtualNetworkLinks.bicep' = {
  name: 'virtualNetworkLinkModule'
  dependsOn: [
    vNetModule
    privateDnsZoneModule
  ]
  params: {
    linkName: '${systemName}-vnet-link'
    privateDnsZoneName: privateDnsZoneModule.outputs.name
    virtualNetworkId: vNetModule.outputs.subscriptionResourceId
  }
}

module apiManagementServiceModule 'ApiManagement/service.bicep' = {
  name: 'apiManagementServiceModule'
  dependsOn: [
    vNetModule
    userAssignedIdentityModule
  ]
  params: {
    defaultResourceName: defaultResourceName
    environmentCode: environmentCode
    subnetName: 'apim'
    vnetResourceId: vNetModule.outputs.subscriptionResourceId
    appGatewayInternalCertificateName: appGatewayInternalCertificateName
    deployTimeKeyVaultName: deployTimeKeyVault.name
    internalDomainName: internalDomainName
    userAssignedManagedIdentityName: userAssignedIdentityModule.outputs.name
  }
}

module privateDnsARecordForApimHostnames 'Network/privateDnsZones/A.bicep' = {
  name: 'privateDnsARecordForApimHostnames'
  params: {
    privateDnsZone: privateDnsZoneModule.outputs.name
    hostnames: apiManagementServiceModule.outputs.domainNames
  }
}

module applicationGatewayModule 'Network/applicationGateways.bicep' = {
  dependsOn: [
    publicIpAddressModule
    apiManagementServiceModule
  ]
  name: 'applicationGatewayModule'
  params: {
    defaultResourceName: defaultResourceName
    environmentCode: environmentCode
    publicIpAddressId: publicIpAddressModule.outputs.pulicIpAddressId
    vnetResourceId: vNetModule.outputs.subscriptionResourceId
    certificateKeyVault: deployTimeKeyVault.name
    appGatewayExternalCertificateName: appGatewayExternalCertificateName
    appGatewayInternalCertificateName: appGatewayInternalCertificateName
    appGatewayExternalHostname: externalDomainName
    apiManagementHostName: 'gateway.${internalDomainName}'
    userAssignedManagedIdentityName: userAssignedIdentityModule.outputs.name
  }
}

output vnetSubscriptionResourceId string = vNetModule.outputs.subscriptionResourceId
output privateDnsZoneName string = privateDnsZoneModule.outputs.name
