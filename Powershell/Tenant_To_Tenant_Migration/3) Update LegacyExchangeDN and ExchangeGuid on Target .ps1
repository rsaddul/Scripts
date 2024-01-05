# Target Tenant
Connect-ExchangeOnline

# Specify the path to your CSV file containing user data
$csvPath = "C:\Site_Staff.csv"

# Import the CSV file
$csvData = Import-Csv -Path $csvPath

# Loop through each row in the CSV
foreach ($row in $csvData) {
    $UserPrincipalName = $row.UserPrincipalName
    $ExchangeGuid = $row.ExchangeGuid
    $LegacyExchangeDN = $row.LegacyExchangeDN

    # Check if the user exists
    $user = Get-MailUser -Identity $UserPrincipalName

    if ($user) {
        # Set the ExchangeGuid for the user
        Set-MailUser -Identity $UserPrincipalName -ExchangeGuid $ExchangeGuid

        # Set the EmailAddresses for the user
        Set-MailUser -Identity $UserPrincipalName -EmailAddresses @{add=$LegacyExchangeDN}

        Write-Host "Updated user: $UserPrincipalName"
    } else {
        Write-Host "User not found for UserPrincipalName: $UserPrincipalName"
    }
}


Disconnect-ExchangeOnline


# Set-MailUser -Identity "rtest" -ExchangeGuid "61720930-2e18-4ba4-bd58-040849bbe8f7" 

#Set-MailUser -Identity "rtest@eduthing.co.uk" –EmailAddresses @{add="x500:/o=ExchangeLabs/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=2be5474947c640f79129f20f3a6d3ac6-75ce9fb5-2b"}
#Get-MailUser -Identity "rtest" | FL exchangeguid,legacyexchangedn

# Confirm if migration worked for one user
#Get-MailUser -Identity "rtest" | FL exchangeguid,legacyexchangedn
#Get-MailUser -Identity "rtest" | Select-Object ExchangeGuid,LegacyExchangeDN | Export-Csv -Path "C:\test.csv" -NoTypeInformation