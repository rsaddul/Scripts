############################
# Developed By Rhys Saddul #
############################

# This script will allow you to export security groups of a member

$Name = Read-Host "Please enter members username"

Get-ADPrincipalGroupMembership -Identity $Name | Sort-Object -Property @{Expression={$_.Name }; Ascending=$True} | Select-Object Name | Export-Csv -Path "C:\$Name.csv" -Encoding UTF8 -NoClobber -NoTypeInformation
