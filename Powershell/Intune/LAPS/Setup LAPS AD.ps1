# Set Variable

$HH = "OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX = "OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY = "OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW = "OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$MID = "OU=HCUC,DC=resource,DC=uc"
$OLD = "OU=Uxbridge College,DC=resource,DC=uc"


# Allow computers in a container to update passwords stored in AD attributes.

Set-LapsADComputerSelfPermission -Identity $HH
Set-LapsADComputerSelfPermission -Identity $UX
Set-LapsADComputerSelfPermission -Identity $HY
Set-LapsADComputerSelfPermission -Identity $HW
Set-LapsADComputerSelfPermission -Identity $OLD
Set-LapsADComputerSelfPermission -Identity $MID


# We will allow this group to view the local admin password

Set-LapsADReadPasswordPermission –Identity $HH –AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADReadPasswordPermission –Identity $UX –AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADReadPasswordPermission –Identity $HY –AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADReadPasswordPermission –Identity $HW –AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADReadPasswordPermission –Identity $OLD –AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADReadPasswordPermission –Identity $MID –AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"


# We will allow this group to reset the local admin password
Set-LapsADResetPasswordPermission -Identity $HH -AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADResetPasswordPermission -Identity $UX -AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADResetPasswordPermission -Identity $HY -AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADResetPasswordPermission -Identity $HW -AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADResetPasswordPermission -Identity $OLD -AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"
Set-LapsADResetPasswordPermission -Identity $MID -AllowedPrincipals "resource\HCUC IT Admin Security - All Staff"



Find-LapsADExtendedRights -Identity $HH
Find-LapsADExtendedRights -Identity $UX
Find-LapsADExtendedRights -Identity $HY
Find-LapsADExtendedRights -Identity $HW
Find-LapsADExtendedRights -Identity $OLD
Find-LapsADExtendedRights -Identity $MID

