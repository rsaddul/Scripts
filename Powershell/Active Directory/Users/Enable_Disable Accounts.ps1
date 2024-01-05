############################
# Developed By Rhys Saddul #
############################

#Disable Accounts

$Group = "Exam_Time"
ForEach ($User in (Get-ADGroupMember $Group))
{  Set-ADUser $User -Enabled $false
}

# Enable Accounts

$Group = "Exam_Time"
ForEach ($User in (Get-ADGroupMember $Group))
{  Set-ADUser $User -Enabled $True
}