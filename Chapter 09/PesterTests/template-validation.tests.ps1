# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    New-AzResourceGroup -Name "PesterRG" -Location "West Europe" -Force | Out-Null
}

Describe "Content Validation" {
    Context "Template Validation" { 
        It "Template azuredeploy.json passes validation" {
            $TemplateParameters = @{}
            $TemplateParameters.Add('storageAccountName', 'strpestertest')

            $output = Test-AzResourceGroupDeployment -ResourceGroupName "PesterRG" -TemplateFile "azuredeploy.json" @TemplateParameters

            $output | Should -BeNullOrEmpty
        } 
     }
}

AfterAll {
    Remove-AzResourceGroup -Name "PesterRG" -Force | Out-Null
}