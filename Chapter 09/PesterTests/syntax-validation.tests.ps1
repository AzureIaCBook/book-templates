BeforeAll {
    $templateProperties = (get-content "azuredeploy.json" -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue)
}

Describe "Syntax Validation" {
    Context "The templates syntax is correct" {
       
        It "Converts from JSON" {
            $templateProperties | Should -Not -BeNullOrEmpty
        }
      
        It "should have a `$schema section" {
            $templateProperties."`$schema" | Should -Not -BeNullOrEmpty
        }
      
        It "should have a contentVersion section" {
            $templateProperties.contentVersion | Should -Not -BeNullOrEmpty
        }
      
        It "should have a parameters section" {
            $templateProperties.parameters | Should -Not -BeNullOrEmpty
        }

        It "must have a resources section" {
            $templateProperties.resources | Should -Not -BeNullOrEmpty
        }
    }
}