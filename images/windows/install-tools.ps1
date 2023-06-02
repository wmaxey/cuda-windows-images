Param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('15', '16', '17')]
    [string[]]
    $msvcVersion
)

$ErrorActionPreference='Stop'
Set-PSDebug -Trace 2

## Make sure the script is local to the directory here.
Push-location "$PSScriptRoot"

## Source and install the below
./scripts/install-cuda.ps1
./scripts/install-lit.ps1
./scripts/install-cmake.ps1
./scripts/install-ninja.ps1

## Save the current environment without MSVC plugged in
New-Item -ItemType Directory -Path "$HOME" -Name "cccl_env"

# Filter these non-portable exported environment variables
$envFilter = `
    "COMPUTERNAME","TEMP","TMP","SystemDrive","SystemRoot","USERNAME","USERPROFILE",`
    "APPDATA","LOCALAPPDATA","NUMBER_OF_PROCESSORS","PROCESSOR_ARCHITECTURE",`
    "PROCESSOR_IDENTIFIER","PROCESSOR_LEVEL","PROCESSOR_REVISION","OS"

$ENV:INSTALLED_MSVC_VERSION=$msvcVersion
Get-ChildItem ENV: | Where-Object { $_.Name -notin $envFilter } | Export-CliXml "$HOME\cccl_env\env-var.clixml"

## Install MSVC
./scripts/install-vs.ps1 -msvcVersion $msvcVersion
./scripts/clear-temp.ps1

Pop-Location