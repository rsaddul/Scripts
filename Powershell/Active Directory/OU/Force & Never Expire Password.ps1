# This script will force users to change their password upon logon and also set the password expired field to never

$ouPath = "OU=YourOU,DC=YourDomain,DC=com"

$users = Get-ADUser -SearchBase $ouPath -Filter * -Properties PasswordExpired, PasswordLastSet, PasswordNeverExpires

foreach ($user in $users) {
    if (-not $user.PasswordExpired -and -not $user.PasswordNeverExpires) {
        $userDN = $user.DistinguishedName
        $user | Set-ADUser -ChangePasswordAtLogon $true -PasswordNeverExpires $true
        Write-Host "Changed password policy for user $($user.Name)"
    }
}

# Test
# $user = Get-ADUser -Identity "studenttest" -Properties PasswordNeverExpires
# $user | Set-ADUser -ChangePasswordAtLogon $true -PasswordNeverExpires $true


