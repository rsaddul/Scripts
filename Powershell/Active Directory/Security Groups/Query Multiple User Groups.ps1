############################
# Developed By Rhys Saddul #
############################

# This script will allow you to export members of multiple usergroups

$Array = @(

"MIS Security - Servers"

)

ForEach ($Server in $Array) {Get-ADGroupMember -Identity $Server | Select Name | Export-Csv -Path "C:\Group.csv" -Encoding UTF8 -NoClobber -NoTypeInformation -Append}