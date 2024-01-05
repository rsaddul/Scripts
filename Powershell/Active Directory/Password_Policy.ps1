Import-Module ActiveDirectory

$defaultPolicy = Get-ADDefaultDomainPasswordPolicy
$defaultPolicy.PasswordHistoryCount = 0
$defaultPolicy.MaxPasswordAge = [System.TimeSpan]::Zero
$defaultPolicy.MinPasswordAge = [System.TimeSpan]::Zero
$defaultPolicy.MinPasswordLength = 14
$defaultPolicy.ComplexityEnabled = $false
$defaultPolicy.ReversibleEncryptionEnabled = $false

Set-ADDefaultDomainPasswordPolicy -Identity "DC=resource,DC=uc" -PasswordHistoryCount $defaultPolicy.PasswordHistoryCount `
    -MaxPasswordAge $defaultPolicy.MaxPasswordAge -MinPasswordAge $defaultPolicy.MinPasswordAge `
    -MinPasswordLength $defaultPolicy.MinPasswordLength -ComplexityEnabled $defaultPolicy.ComplexityEnabled `
    -ReversibleEncryptionEnabled $defaultPolicy.ReversibleEncryptionEnabled
