param privateDnsZoneName string

resource pvtDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

output name string = pvtDns.name
