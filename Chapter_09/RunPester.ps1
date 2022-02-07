param (
    [Parameter(Mandatory = $true)]
    [string]
    $ModulePath,

    [Parameter(Mandatory=$false)]
    [string]
    $ResultsPath,

    [Parameter(Mandatory=$false)]
    [string]
    $Tag = "UnitTests"
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

Write-Host "Pester version: $($pesterModule.Version)"
$pesterModule | Import-Module

if (!(Test-Path -Path $ResultsPath)) {
    New-Item -Path $ResultsPath -ItemType Directory -Force | Out-Null
}

Write-Host "Finding tests in $ModulePath"
$tests = (Get-ChildItem -Path $ModulePath "*tests.ps1" -Recurse).FullName

$container = New-PesterContainer -Path $tests

$configuration = [PesterConfiguration]@{
    Run          = @{
        Container = $container
    }
    Output       = @{
        Verbosity = 'Detailed'
    }
    Filter = @{
        Tag = $Tag
    }
    TestResult   = @{
        Enabled      = $true
        OutputFormat = "NUnitXml"
        OutputPath   = "$($ResultsPath)\Test-Pester.xml"
    }
}

Invoke-Pester -Configuration $configuration