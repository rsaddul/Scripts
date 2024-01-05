##########################
#Developed by Rhys Saddul#
##########################

$PhoneAccounts = Import-csv "C:\Users\rsaddul\OneDrive - HCUC\Documents\Extension_List.csv"
$OU = "OU=Phone Accounts,OU=Shared Accounts,OU=HCUC,DC=resource,DC=uc"

ForEach ($PhoneAccount in $PhoneAccounts) {
    $UPN = $PhoneAccount.UserPrincipalName
    $Name = $PhoneAccount.DisplayName 

If (Get-ADUser -Filter {UserPrincipalName -eq $UPN}) {
        Write-Host "$UPN Account Exists on AD"
            Get-ADUser -Filter {UserPrincipalName -eq $UPN} | Move-ADObject -TargetPath $OU -WhatIf
        "Moved PhoneAccount $Name" | Out-file "C:\Move_PhoneAccounts.txt" -Append -Encoding ascii
}
Else  {
        Write-Host "$UPN Account Exists on Cloud"
    }

}
