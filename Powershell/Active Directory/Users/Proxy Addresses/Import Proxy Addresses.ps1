# Import the CSV file
$users = Import-Csv -Path "C:\Users\rsaddul\OneDrive - HCUC\Pictures\Import Proxy Addresses.csv"

# Loop through each user in the CSV
foreach ($user in $users) {
    # Get the user object from Active Directory
    $adUser = Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -Properties EmailAddress, ProxyAddresses, UserPrincipalName, Description

    # Set the user's email address to the value in Proxy Address 1 without "SMTP:"
    $adUser.EmailAddress = $user.'Proxy Address 1' -replace '^SMTP:', ''

    # Remove the existing proxy addresses for the user
    $adUser.ProxyAddresses.Clear() 

    # Loop through each column in the CSV that starts with "Proxy Address"
    $user.psobject.Properties | Where-Object { $_.Name -like 'Proxy Address*' } | ForEach-Object {
        # If the value is not empty and starts with "SMTP:", add it as a proxy address
        if ($_.Value -match '^SMTP:') {
            $adUser.ProxyAddresses.Add($_.Value) 
        }
        # If the value is not empty and doesn't start with "SMTP:", add it as a proxy address with "SMTP:" prefix
        elseif (-not [string]::IsNullOrWhiteSpace($_.Value)) {
            $adUser.ProxyAddresses.Add("SMTP:$($_.Value)") 
        }
    }

    # Set the user's UPN suffix to "@hruc.ac.uk"
    $adUser.UserPrincipalName = "$($adUser.SamAccountName)@hruc.ac.uk" 

    # Save the changes to Active Directory
    Set-ADUser -Instance $adUser 
}
