$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$ValueName = "com.squirrel.Teams.Teams"

# Check if the registry key and value exist
if (Test-Path $RegistryPath) {
    $key = Get-ItemProperty -Path $RegistryPath
    if ($key.PSObject.Properties.Name -contains $ValueName) {
        Write-Host "Registry value '$ValueName' exists in $RegistryPath. Deleting it..."
        Remove-ItemProperty -Path $RegistryPath -Name $ValueName
        Write-Host "Registry value '$ValueName' deleted. Exiting with code 0."
        Exit 0
    }
}

Write-Host "Registry value '$ValueName' does not exist. No action required. Exiting with code 1."
Exit 1
