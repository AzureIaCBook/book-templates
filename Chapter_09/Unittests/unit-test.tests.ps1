# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    $resourceGroupName = 'PesterRG'
    New-AzResourceGroup -Name $resourceGroupName -Location "West Europe" -Force | Out-Null

    $storageAccountName = 'unitteststr'
    $TemplateParameters = @{
        storageAccountName = $storageAccountName
        location = 'West Europe'
        sku = 'Premium'
    }

    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "$PSScriptRoot/storageaccount.bicep" @TemplateParameters

    $storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName
}

Describe "Deployment Validation" -Tag "UnitTests" {
    Context "StorageAccount validation" {

        It "Storage account should exist" {
            $storageAccount | Should -not -be $null
        }

        It "Storage account should have tier 'Premium'" {
            $storageAccount.Sku.Name | Should -Be "Premium_LRS"
        }
    }
}

AfterAll {
    Remove-AzResourceGroup -Name "PesterRG" -Force | Out-Null
}