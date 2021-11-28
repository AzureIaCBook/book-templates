var contributorRoleId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var userPrincipalId = 'e66a1b1e-c8ae-4d6f-b5d1-5ef6337c2b88'

resource storageRBACRef 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: guid('${contributorRoleId}${userPrincipalId}')
  properties: {
    roleDefinitionId: '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/${contributorRoleId}'
    principalId: userPrincipalId
  }
}
