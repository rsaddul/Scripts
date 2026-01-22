############################
# Developed by Rhys Saddul #
############################

#Clear AD Attributes

$emptyParams = @()
$emptyParams += "msRTCSIP-DeploymentLocator"
$emptyParams += "msRTCSIP-FederationEnabled"
$emptyParams += "msRTCSIP-InternetAccessEnabled"
$emptyParams += "msRTCSIP-OptionFlags"
$emptyParams += "msRTCSIP-Line"
$emptyParams += "msRTCSIP-PrimaryHomeServer"
$emptyParams += "msRTCSIP-PrimaryUserAddress"
$emptyParams += "msRTCSIP-UserEnabled"
$emptyParams += "msRTCSIP-UserPolicies"
$emptyParams += "msRTCSIP-UserRoutingGroupId"

$Name = Read-Host "Please enter staff members full name"
Get-ADUser -Filter { Name -eq $Name } | Select-Object SamAccountName | Format-Table -HideTableHeaders

Write-Host "Copy the above text" -ForegroundColor Green
$Member = Read-Host "Please paste the text you copied"
Write-Host "Removing the following attributes $emptyParams for $Member" -ForegroundColor Red
Set-ADUser -Identity $($Member) -Clear $emptyParams -WhatIf

