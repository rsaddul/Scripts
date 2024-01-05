
# Username and Password
$username = "Helpdesk"
$password = ConvertTo-SecureString "Nic3War303%" -AsPlainText -Force  # Super strong plane text password here (yes this isn't secure at all)

# Creating the user
New-LocalUser -Name "$username" -Password $password -FullName "$username" -Description "Local Intune Administrator" -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword

# Add Helpdesk to local Administrators group
Add-LocalGroupMember -Group Administrators -Member $username