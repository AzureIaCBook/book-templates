# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    $resoureGroupName = 'PesterRG'
    New-AzResourceGroup -Name $resoureGroupName -Location "West Europe" -Force | Out-Null

    $storageAccountName = 'unitteststr'
    $TemplateParameters = @{}
    $TemplateParameters.Add('name', $storageAccountName)
    $TemplateParameters.Add('location', 'West Europe') 
    $TemplateParameters.Add('sku', 'Premium') 

    New-AzResourceGroupDeployment -ResourceGroupName $resoureGroupName -TemplateFile "$PSScriptRoot/storageaccount.bicep" @TemplateParameters

    $storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resoureGroupName
}

Describe "Deployment Validation" -Tag "UnitTests" {
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