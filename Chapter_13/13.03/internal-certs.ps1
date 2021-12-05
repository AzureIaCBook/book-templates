$trustedRootCert = New-SelfSignedCertificate `
    -Type Custom `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeySpec Signature `
    -Subject "CN=Your Common Name" `
    -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 `
    -KeyLength 4096 `
    -KeyUsageProperty Sign `
    -KeyUsage CertSign `
    -NotAfter (Get-Date).AddMonths(24)
 
$sslCert = New-SelfSignedCertificate `
    -Type Custom `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeySpec Signature `
    -Subject "CN=*.your-internal-domain.int" `
    -DnsName "*.your-internal-domain.int","your-internal-domain.int" `
    -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 `
    -KeyLength 2048 `
    -Signer $trustedRootCert
 
Export-Certificate  `
    -Type CERT `
    -Cert $trustedRootCert `
    -FilePath .\certificate-trustedroot.cer
 
$pfxPassword = ConvertTo-SecureString -String "SomePassword123" -AsPlainText -Force
Export-PfxCertificate `
    -ChainOption BuildChain `
    -Cert $sslCert `
    -FilePath .\certificate.pfx `
    -Password $pfxPassword