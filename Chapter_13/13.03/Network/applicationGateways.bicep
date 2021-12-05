param defaultResourceName string
param environmentCode string
param vnetResourceId string
param publicIpAddressId string

param certificateKeyVault string
param appGatewayExternalCertificateName string
param appGatewayInternalCertificateName string
param appGatewayExternalHostname string
param apiManagementHostName string

param userAssignedManagedIdentityName string

var appGwSku = environmentCode == 'prd' ? 'WAF_v2' : 'Standard_v2'

var resourceName = '${defaultResourceName}-agw'
var appgw_id = resourceId('Microsoft.Network/applicationGateways', resourceName)
var externalHostName = environmentCode == 'prd' ? 'api.${appGatewayExternalHostname}' : 'api-${environmentCode}.${appGatewayExternalHostname}'

resource existing_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: userAssignedManagedIdentityName
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-03-01' = {
  name: resourceName
  location: resourceGroup().location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${existing_identity.id}': {}
    }
  }
  properties: {
    sku: {
      name: appGwSku
      tier: appGwSku
    }
    enableHttp2: true
    sslPolicy: {
      policyType: 'Predefined'
      policyName: 'AppGwSslPolicy20170401S'
    }
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 10
    }
    webApplicationFirewallConfiguration: (environmentCode == 'prd') ? {
      enabled: true
      firewallMode: 'Detection'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.1'
    } : json('null')
    sslCertificates: [
      {
        name: 'ssl-appgw-external'
        properties: {
          keyVaultSecretId: 'https://${certificateKeyVault}${environment().suffixes.keyvaultDns}/secrets/${appGatewayExternalCertificateName}'
        }
      }
      {
        name: 'certificate-int'
        properties: {
          keyVaultSecretId: 'https://${certificateKeyVault}${environment().suffixes.keyvaultDns}/secrets/${appGatewayInternalCertificateName}'
        }
      }
    ]
    trustedRootCertificates: [
      {
        name: 'certificate-int-cer'
        properties: {
          data: 'trused-root-cert-binary-encoded-string'
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddressId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'Port443'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backend-apim'
        properties: {
          backendAddresses: [
            {
              fqdn: apiManagementHostName
            }
          ]
        }
      }
    ]
    probes: [
      {
        name: 'apimgw-probe'
        properties: {
          protocol: 'Https'
          host: apiManagementHostName
          path: '/status-0123456789abcdef'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'apim_gw_httpsetting'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: apiManagementHostName
          requestTimeout: 120
          probe: {
            id: '${appgw_id}/probes/apimgw-probe'
          }
          trustedRootCertificates: [
            {
              id: '${appgw_id}/trustedRootCertificates/certificate-int-cer'
            }
          ]
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: '${vnetResourceId}/subnets/gateway'
          }
        }
      }
    ]

    httpListeners: [
      {
        name: 'apim-https-listener'
        properties: {
          protocol: 'Https'
          hostName: externalHostName
          frontendIPConfiguration: {
            id: '${appgw_id}/frontendIPConfigurations/appGwPublicFrontendIp'
          }
          frontendPort: {
            id: '${appgw_id}/frontendPorts/Port443'
          }
          sslCertificate: {
            id: '${appgw_id}/sslCertificates/ssl-appgw-external'
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'routing-apim'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${appgw_id}/httpListeners/apim-https-listener'
          }
          backendAddressPool: {
            id: '${appgw_id}/backendAddressPools/backend-apim'
          }
          backendHttpSettings: {
            id: '${appgw_id}/backendHttpSettingsCollection/apim_gw_httpsetting'
          }
        }
      }
    ]
  }
}
