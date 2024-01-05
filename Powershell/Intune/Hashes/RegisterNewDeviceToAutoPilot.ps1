# InTune Registration Script for new HCUC devices by Rhys Saddul
# This script should only be run on devices that have not already been registered to the HCUC InTune O365 tenant

Clear-Host
Write-Host "HCUC Autopilot Online Registration"
Write-Host "================================="
"`n"
$PackageInstaller = (Get-PackageProvider | Where-Object {$_.name -like 'NuGet'})
If ($PackageInstaller -eq $null) {
Write-Host "NuGet package provider not present, installing online repo..."
Install-PackageProvider -Name NuGet -Force
}
$Policy = Get-ExecutionPolicy
$PolicyName = ($Policy.ToString())
If (($Policy -eq 'Bypass') -or ($Policy -eq 'Unrestricted')) {Write-Host "Execution policy already set as $PolicyName."} else { Set-ExecutionPolicy -ExecutionPolicy Bypass -Force}
$Repo = Get-PSRepository -Name PSGallery
$RepoTrusted = ($Repo.InstallationPolicy)
If ($RepoTrusted -ne 'Trusted') {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted}
Install-Script -Name Get-WindowsAutoPilotInfo
"`n"
Write-Host "Connecting to Microsoft Online Services to register this device in the InTune portal..."
Write-Host "Please make sure to accept and install any modules or components that may be automatically installed by this script."
Write-Host "IMPORTANT: " -ForegroundColor Yellow -NoNewline; Write-Host "This process will connect to MS services and place this device in a queue to be registered. This process may take up to an hour, so please do not disconnect or turn off your computer until the process has completed."
"`n"
Get-WindowsAutoPilotInfo.ps1 -Online
Write-Host "Registration process has completed. You can now continue the OOBE process to complete setup."
#shutdown -r -t 15
