param([string] $groupName, $tenantId)

$ErrorActionPreference = 'Stop'

$clientId = $env:clientId    #A
$clientSecret = $env:clientSecret

$Body = @{
    'tenant' = $tenantId
    'client_id' = $clientId
    'scope' = 'https://graph.microsoft.com/.default'
    'client_secret' = $clientSecret
    'grant_type' = 'client_credentials'
}

$url = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

$Params = @{
    'Uri' = $url
    'Method' = 'Post'
    'Body' = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$AuthResponse = Invoke-RestMethod @Params    #B

$Headers = @{
    'Authorization' = "Bearer $($AuthResponse.access_token)"
}
$groupUrl = "https://graph.microsoft.com/v1.0/groups?`$filter=displayname eq '$groupName'"
$groupResult = Invoke-RestMethod -Uri $groupUrl -Headers $Headers    #C

$groupId = $groupResult.value[0].id

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['groupId'] = $groupId    #D

Write-Host "Finished!"