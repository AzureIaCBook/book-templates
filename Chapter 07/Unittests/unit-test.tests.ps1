# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    $resoureGroupName = 'PesterRG'
    New-AzResourceGroup -Name $resoureGroupName -Location "West Europe" -Force | Out-Null

    $storageAccountName = 'unitteststr'
    $TemplateParameters = @{
        storageAccountName = $storageAccountName
        location = 'West Europe'
        sku = 'Premium'
    }

    New-AzResourceGroupDeployment -ResourceGroupName $resoureGroupName -TemplateFile "$PSScriptRoot/storageaccount.bicep" @TemplateParameters

    $storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resoureGroupName
}

Describe "Deployment Validation" -Tag "UnitTests" {
    Context "StorageAccount validation" {

        It "Storage account should exist" {
            $storageAccount | Should -not -be $null
        }

        It "Storage account should have tier 'Premium'" {
            $storageAccount.Sku.Tier | Should -Be "Premium"
        }
    }
}

AfterAll {
    Remove-AzResourceGroup -Name "PesterRG" -Force | Out-Null
}