$Users = Import-Csv -Path "C:\Users\rsaddul\OneDrive - HCUC\Documents\Profile Fix.csv"

Foreach ($User in $Users) {

Try {
$Name = $User.SamAccountName
$HomePath = $User.'HomeDirectory '
$HomeDrive = $User.'HomeDrive '

Set-ADUser -Identity $Name -HomeDirectory $HomePath -HomeDrive F:
} 
Catch {
$error[0].Exception | Out-File c:\log.txt -Append
}
}

