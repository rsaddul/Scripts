# Developed by Rhys Saddul

# Checks users UPN to see if their AD account is disabled

# Specify the path to the CSV file
$csvPath = "C:\temp\input.csv"
$logPath = "C:\temp\disabled_accounts.log"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Initialize an array to store disabled accounts
$disabledAccounts = @()

# Retrieve the AD user account
foreach ($user in $users) {
    $upn = $user.UserPrincipalName

    $adUser = Get-ADUser -Filter "UserPrincipalName -eq '$upn'" -Properties Enabled -ErrorAction SilentlyContinue

    if ($adUser) {
        # Check the Enabled status of the AD user
        $isEnabled = $adUser.Enabled

        # Print the result
        Write-Output "User: $upn | Enabled: $isEnabled"

        # Check if the account is disabled
        if (-not $isEnabled) {
            $disabledAccounts += $upn
        }
    } else {
        # User account not found in AD
        Write-Output "User: $upn | Account not found in AD"
    }
}

# Export disabled accounts to a log file
$disabledAccounts | Out-File -FilePath $logPath -Encoding UTF8

Write-Output "Disabled accounts exported to: $logPath"
