############################
# Developed By Rhys Saddul #
############################

# This script will allow you to export users of a usergroup

#Specify the AD Group Name
$Usergroup = read-host -Prompt "Enter UserGroup Name"

#This will query the group and export the users name into a CSV
Get-ADGroupMember -Identity $Usergroup | Select Name | Export-Csv -Path "C:\$Usergroup.csv" -Encoding UTF8 -NoClobber -NoTypeInformation