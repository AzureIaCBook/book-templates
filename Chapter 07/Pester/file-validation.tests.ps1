Describe "Template Validation" {
    Context "Template files exist" {
       
        It "Has a JSON template" {        
            "azuredeploy.json" | Should -Exist
        }

        It "Has a test parameters file" {        
            "azuredeploy.parameters.test.json" | Should -Exist
        }

        It "Has a production parameters file" {        
            "azuredeploy.parameters.prod.json" | Should -Exist
        }
    }
}