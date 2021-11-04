BeforeAll {
    $jsonTemplate = (get-content "azuredeploy.json" -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue)
    $rawTemplate = get-content "azuredeploy.json"

    $parametersUsage = [System.Text.RegularExpressions.RegEx]::Matches($rawTemplate, "parameters(\(\'\w*\'\))") | Select-Object -ExpandProperty Value -Unique
}

Describe "Content Validation" -Tag "UnitTests" {
    
    Context "Referenced Parameters" {
        It "should have a parameter called <parametersUsage>"  {
            $parametersUsage = $parametersUsage.SubString($parametersUsage.IndexOf("'") + 1).Replace("')", "")
    
            $jsonTemplate.parameters.$parametersUsage | Should -Not -Be $null
        }
    }
}