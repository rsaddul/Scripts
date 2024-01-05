$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$ValueName = "com.squirrel.Teams.Teams"

# Check if the registry key and value exist
if (Test-Path $RegistryPath) {
    $key = Get-ItemProperty -Path $RegistryPath
    if ($key.PSObject.Properties.Name -contains $ValueName) {
        Write-Host "Registry value '$ValueName' exists in $RegistryPath. Exiting with code 1."
        #Exit 1
    } else {
        Write-Host "Registry value '$ValueName' does not exist in $RegistryPath. Exiting with code 0."
        #Exit 0
    }
}