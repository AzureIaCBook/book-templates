# This test requires an authenticated session, use Connect-AzAccount to login

BeforeAll {
    New-AzDeployment -Location "WestEurope" -TemplateFile "mainDeployment.bicep"
    dotnet publish MinimalFrontend/testweb.csproj --configuration Release -o ./MinimalFrontend/myapp
    Compress-Archive -Path ./MinimalFrontend/myapp/* -DestinationPath ./MinimalFrontend/myapp.zip -Force
    Publish-AzWebApp -ResourceGroupName rg-firstvnet -Name bicepfrontend -ArchivePath $PSScriptRoot/MinimalFrontend/myapp.zip -Force
}

Describe "Deployment Validation" {
    Context "End 2 end test" {

        It "Frontend should be available and respond with 200" {
            
            $Result = try { 
                Invoke-WebRequest -Uri "https://bicepfrontend.azurewebsites.net/" -Method GET
            }
            catch { 
                $_.Exception.Response 
            }

            $statusCodeInt = [int]$Result.StatusCode    
            $statusCodeInt | Should -be 200
        }

        It "API should be locked and respond with 403" {
            
            $Result = try { 
                Invoke-WebRequest -Uri "https://bicepapi.azurewebsites.net/" -Method GET
            }
            catch { 
                $_.Exception.Response 
            }

            $statusCodeInt = [int]$Result.StatusCode    
            $statusCodeInt | Should -be 403
        }
    }
}

AfterAll {
    Remove-AzResourceGroup -Name "rg-firstvnet" -Force | Out-Null
    Remove-AzResourceGroup -Name "rg-secondvnet" -Force | Out-Null
}