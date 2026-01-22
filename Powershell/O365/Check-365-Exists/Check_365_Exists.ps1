# Import CSV File
$csvPath = "C:\Users\RhysSaddul\Downloads\Check_365_Exists.csv"
$users = Import-Csv -Path $csvPath

# Connect to Exchange Online
Connect-ExchangeOnline

# Retrieve all users (to avoid querying multiple times)
$allUsers = Get-User -ResultSize unlimited

# Prepare results array
$results = @()

# Loop through each user in CSV
foreach ($user in $users) {
    $upn = $user.UserPrincipalName
    $exists = if ($allUsers.UserPrincipalName -contains $upn) { "Yes" } else { "No" }

    # Add results to array
    $results += [PSCustomObject]@{
        UserPrincipalName = $upn
        Exists = $exists
    }
}

# Export results to CSV
$results | Export-Csv -Path "C:\Users\RhysSaddul\Downloads\Results.csv" -NoTypeInformation

# Display results in console
$results | Format-Table -AutoSize

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
