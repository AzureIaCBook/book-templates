az group create -n "DeploymentScriptExample" -l westeurope

az storage account create -n dsexample -g "DeploymentScriptExample" -l westeurope --sku Standard_LRS

az storage container create -n dsscriptcontainer --account-name dsexample --public-access blob

az storage blob upload --account-name dsexample -f ./script.ps1 -c dsscriptcontainer -n script.ps1

az ad sp create-for-rbac -n deploymentIdentity | ConvertFrom-Json

$identity = az ad sp list --display-name deploymentIdentity | ConvertFrom-Json

$spId = $identity.objectId

$graphResourceId=$(az ad sp list --display-name "Microsoft Graph" --query [0].objectId --out tsv)

$appRoleId=$(az ad sp list --display-name "Microsoft Graph" --query "[0].appRoles[?value=='Group.Read.All' && contains(allowedMemberTypes, 'Application')].id" --output tsv)

$uri="https://graph.microsoft.com/v1.0/servicePrincipals/$spId/appRoleAssignments"

$body="{'principalId':'$spId','resourceId':'$graphResourceId','appRoleId':'$appRoleId'}"

az rest --method post --uri $uri --body $body --headers "Content-Type=application/json"