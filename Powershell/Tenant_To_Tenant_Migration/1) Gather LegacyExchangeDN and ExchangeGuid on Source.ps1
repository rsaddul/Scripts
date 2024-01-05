# Source Tenant
Connect-ExchangeOnline

#Get-Mailbox -Identity "rtest@mintsupport.co.uk" | Select-Object Name, ExchangeGuid, @{Name="LegacyExchangeDN"; Expression={"x500:" + $_.LegacyExchangeDN}}, UserPrincipalName | Export-Csv -Path "C:\Mint_ExchangeGuid.csv" -NoTypeInformation

# Get mailbox properties for all users
$mailboxProperties = Get-Mailbox | ForEach-Object {
    $user = Get-User -Identity $_.UserPrincipalName
    $properties = [PSCustomObject]@{
        DisplayName = $user.DisplayName
        FirstName = $user.FirstName
        LastName = $user.LastName
        LegacyExchangeDN = "x500:" + $user.LegacyExchangeDN
        UserPrincipalName = $user.UserPrincipalName
        ExchangeGuid = $_.ExchangeGuid
    }
    $properties
}

# Export the properties to a CSV file
$mailboxProperties | Export-Csv -Path "C:\Site_Staff.csv" -NoTypeInformation


#Disconnect-ExchangeOnline


<#
$user = Get-User -Identity "rtest@mintsupport.co.uk"
$mailbox = Get-Mailbox -Identity $user.Identity
$properties = New-Object PSObject -Property @{
    DisplayName = $user.DisplayName
    FirstName = $user.FirstName
    LastName = $user.LastName
    LegacyExchangeDN = $user.LegacyExchangeDN
    UserPrincipalName = $user.UserPrincipalName
    ExchangeGuid = $mailbox.ExchangeGuid
}

# Export the properties to a CSV file
$properties | Export-Csv -Path "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\UserProperties.csv" -NoTypeInformation
#>


#Remove-MsolUser -UserPrincipalName "Migration.Test@eduthing.onmicrosoft.com" -RemoveFromRecycleBin -Force