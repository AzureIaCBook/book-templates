# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    New-AzDeployment -Location "WestEurope" -TemplateFile "$PSScriptRoot/mainDeployment.bicep"

    $vnetPeering = Get-AzVirtualNetworkPeering -Name "peering-to-remote-vnet" -VirtualNetworkName "vnet-second" -ResourceGroupName "rg-secondvnet"
}

Describe "Deployment Validation" {
    Context "Integration test" {

        It "Vnet peering should exist" {
            $vnetPeering | Should -not -be $null
        }

        It "Peering status should be 'Connected'" {
            $vnetPeering.PeeringState | Should -Be "Connected"
        }
    }
}

AfterAll {
    Remove-AzResourceGroup -Name "rg-firstvnet" -Force | Out-Null
    Remove-AzResourceGroup -Name "rg-secondvnet" -Force | Out-Null
}