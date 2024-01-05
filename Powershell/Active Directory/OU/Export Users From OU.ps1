############################
# Developed By Rhys Saddul #
############################

# This script will export users from an OU

$OUpath = 'OU=ServiceAccounts,OU=Azure,OU=HCUC,DC=resource,DC=uc'
$Name = Read-Host -Prompt "Name of OU Folder"

$ExportPath = "C:\$Name.csv"

Get-ADUser -Filter * -SearchBase $OUpath | Select-object SamAccountName,UserPrincipalName,DistinguishedName | Export-Csv -NoType $ExportPath