# Authenticate (uncomment when running for real)
Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All"

# Path to your CSV
$csvFilePath = "C:\Users\RhysSaddul\OneDrive - eduthing\Desktop\SMH\New Accounts\Create_Accounts.csv"

# Import CSV
$usersData = Import-Csv -Path $csvFilePath

# Loop through and create users
foreach ($userRow in $usersData) {
    $upn = $userRow.'User name [userPrincipalName] Required'

    # Check if user already exists
    $existingUser = Get-MgUser -UserId $upn -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Host "⚠️ User $upn already exists — skipping."
        continue
    }

    $userParams = @{
        DisplayName       = $userRow.'Name [displayName] Required'
        UserPrincipalName = $upn
        PasswordProfile   = @{
            Password                      = $userRow.'Initial password [passwordProfile] Required'
            ForceChangePasswordNextSignIn = $false
        }
        AccountEnabled = $true
        MailNickName   = if ($userRow.mailNickName -and $userRow.mailNickName -ne "") {
                            $userRow.mailNickName
                         } else {
                            ($upn -split "@")[0]
                         }
    }

    # Map FirstName/LastName
    if ($userRow.FirstName) { $userParams.GivenName = $userRow.FirstName }
    if ($userRow.LastName)  { $userParams.Surname   = $userRow.LastName }

    # Add optional attributes only if not empty
    if ($userRow.Department)    { $userParams.Department    = $userRow.Department }
    if ($userRow.City)          { $userParams.City          = $userRow.City }
    if ($userRow.Country)       { 
        $country = if ($userRow.Country -eq "UK") { "GB" } else { $userRow.Country }
        $userParams.Country = $country
    }
    if ($userRow.State)         { $userParams.State         = $userRow.State }
    if ($userRow.PostalCode)    { $userParams.PostalCode    = $userRow.PostalCode }
    if ($userRow.StreetAddress) { $userParams.StreetAddress = $userRow.StreetAddress }
    if ($userRow.MobilePhone)   { $userParams.MobilePhone   = $userRow.MobilePhone }

    try {
        # Create the user
        $null = New-MgUser @userParams
        Write-Host "✅ User $upn created successfully." -ForegroundColor Green
    } catch {
        Write-Host "❌ Error creating user ${upn}:" -ForegroundColor Red
        $_ | Format-List * -Force   # show full error details
    }

    # Optional: add a short delay to avoid throttling if many users
    Start-Sleep -Milliseconds 200
}

# Disconnect (uncomment when running for real)
#Disconnect-MgGraph
Write-Host "Bulk user creation completed."
