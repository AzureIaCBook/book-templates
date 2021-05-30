# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    New-AzResourceGroup -Name "PesterRG" -Location "West Europe" -Force | Out-Null

    $TemplateParameters = @{}
    $TemplateParameters.Add('storageAccountName', 'strpestertest')

    New-AzResourceGroupDeployment -ResourceGroupName "PesterRG" -TemplateFile "azuredeploy.json" @TemplateParameters

    $storageAccount = Get-AzStorageAccount -Name "strpestertest" -ResourceGroupName "PesterRG"
}

Describe "Deployment Validation" {
    Context "StorageAccount validation" {

        It "Storage account should exist" {
            $storageAccount | Should -not -be $null
        }

        It "Storage account should be of type 'StorageV2'" {
            $storageAccount.Sku.Tier | Should -Be "Premium"
        }
    }
}

AfterAll {
    Remove-AzResourceGroup -Name "PesterRG" -Force | Out-Null
}