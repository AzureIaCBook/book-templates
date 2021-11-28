param privateDnsZone string
param hostnames array

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZone
}

resource dnsARecordForProxy 'Microsoft.Network/privateDnsZones/A@2020-06-01' = [for dnsEntry in hostnames: {
  name: '${dnsZone.name}/${dnsEntry.name}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: dnsEntry.ipAddress
      }
    ]
  }
}]
