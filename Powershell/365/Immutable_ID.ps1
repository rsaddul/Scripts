##########################
#Developed by Rhys Saddul#
##########################

#Checks if MicrosoftTeams exists and install if not
$Module = Get-Module -Name MSOnline
$Version = Get-installedModule -Name MSOnline | Where-Object {$_.Version -like "*4.6.0*"}

If (-not $Module) {
Write-Host "Office 365 module not installed, will now attempt to install/update module" -ForegroundColor Red
Install-Module MSOnline -Force -AllowClobber
}
Else {
Write-Host "Office 365 module is installed" -ForegroundColor Green
}	

#Connect to MSOnline
Connect-MsolService

$Email = Read-Host "Please enter employee email address"
$Username = Read-Host "Please enter employee username"

#Get User Immutable ID from Azure
$Convert = Get-MsolUser -UserPrincipalName $Email
Write-Host "Getting Immutable ID from Azure" -ForegroundColor Red
$ID = $Convert.ImmutableId
Write-Host "Immutable ID for $Email is $ID" -ForegroundColor Green


#Convert to GUID Format
$GUID = Read-Host "Please enter the Immutable ID"
Write-Host "Converting $ID into GUID format" -ForegroundColor Red
$GUID = [GUID][system.convert]::FromBase64String("$GUID")
Write-Host "GUID for $Email is $GUID" -ForegroundColor Green


$Title = "Clear Immutable ID"
$Confirmation = Read-Host "Press Enter:"
$choices  = '&Yes', '&No'

#User prompts to see what site to be setup at
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
If ($decision -eq 0) {

#Clearing the ImmutableID
Set-MSOLUser -UserPrincipalName $Email -ImmutableID "$null"
Write-Host "Immutable ID has now been cleared for $Email" -ForegroundColor Red
}
Else{
#Create GUID to Immutable ID format
$immutableId = [System.Convert]::ToBase64String($GUID.ToByteArray())


#Set the ImmutableID
Get-MsolUser -UserPrincipalName $Email | Set-MsolUser -ImmutableId $immutableId
Write-Host "Immutable ID has now been set for $Email" -ForegroundColor Green
}


