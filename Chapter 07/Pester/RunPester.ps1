param (
    [Parameter(Mandatory = $true)]
    [string]
    $ModulePath,

    [Parameter(Mandatory=$false)]
    [string]
    $ResultsPath
)
# Install Bicep
curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
chmod +x ./bicep
sudo mv ./bicep /usr/local/bin/bicep

# Install Pester if needed
$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
if (!$pesterModule) { 
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion "5.0"
        $pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

Write-Host "Pester version: $($pesterModule.Version.Major).$($pesterModule.Version.Minor).$($pesterModule.Version.Build)"
$pesterModule | Import-Module

if (!(Test-Path -Path $ResultsPath)) {
    New-Item -Path $ResultsPath -ItemType Directory -Force | Out-Null
}

Write-Host "Finding tests in $($ModulePath)"
$tests = (Get-ChildItem -Path $($ModulePath) -Recurse | Where-Object {$_.Name -like "*tests.ps1"}).FullName

$config = [PesterConfiguration]::Default
$config.TestResult.Enabled = $true
$config.TestResult.OutputPath = "$ResultsPath\Test-Pester.xml"
$config.TestResult.OutputFormat = "NUnitXml"
Invoke-Pester $tests -Configuration $config -Tag "UnitTests" 