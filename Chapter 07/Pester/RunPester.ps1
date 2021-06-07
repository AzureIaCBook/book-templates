param (
    [Parameter(Mandatory = $true)]
    [string]
    $ModulePath,

    [Parameter(Mandatory = $false)]
    [switch]
    $Publish,

    [Parameter(Mandatory=$false)]
    [string]
    $ResultsPath
)

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

if ($Publish) {
    if (!(Test-Path -Path $ResultsPath)) {
        New-Item -Path $ResultsPath -ItemType Directory -Force | Out-Null
    }
}

Write-Host "Finding tests in $($ModulePath)"

$tests = (Get-ChildItem -Path $($ModulePath) -Recurse | Where-Object {$_.Name -like "*tests.ps1"}).FullName

if ($Publish) {
    $files = (Get-ChildItem -Recurse | Where-Object {$_.Name -like "*.psm1" -or $_.Name -like "*.ps1" -and $_.FullName -notlike "*\Pipelines\*"}).FullName
    Invoke-Pester $tests -OutputFile "$ResultsPath\Test-Pester.xml" -OutputFormat NUnitXml -CodeCoverage $($files.FullName) -CodeCoverageOutputFile "$($ResultsPath)\Pester-Coverage.xml" -CodeCoverageOutputFileFormat JaCoCo -Tag "UnitTests" 
} else {
    Invoke-Pester $tests
}