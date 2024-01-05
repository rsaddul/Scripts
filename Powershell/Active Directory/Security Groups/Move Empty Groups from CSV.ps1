##########################
#Developed by Rhys Saddul#
##########################

$Groups = Import-csv "C:\Users\rsaddul\OneDrive - HCUC\Documents\Empty_Groups.csv"
$OU = "OU=Empty Groups,OU=Groups To Be Deleted,OU=HCUC,DC=resource,DC=uc"

ForEach ($Group in $Groups) {

Get-ADGroup -Identity $Group.Group | Move-ADObject -TargetPath $OU -WhatIf

$Name = $Group.Group 
Write-Host "Moving $Name to target OU" -ForegroundColor Green
"Moved usergroup $Name" | Out-file "C:\Moved_Groups.txt" -Append -Encoding ascii

}