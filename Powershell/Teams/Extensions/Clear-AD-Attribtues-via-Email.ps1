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


$Member = Read-Host "Please enter staff members AD Account"
Write-Host "Removing the following attributes $emptyParams for $Member" -ForegroundColor Red
Set-ADUser -Identity $($Member) -Clear $emptyParams

