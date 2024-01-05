# Target Tenant
Connect-ExchangeOnline

# Specify the path to your CSV file containing user data
$csvPath = "C:\Site_Staff.csv"

# Import the CSV file
$userData = Import-Csv -Path $csvPath

# Loop through each row and create mail users
foreach ($user in $userData) {
    $userParams = @{
        Name = $user.DisplayName
        FirstName = $user.FirstName
        LastName = $user.LastName
        UserPrincipalName = $user.UserPrincipalName
        ExternalEmailAddress = $user.ExternalEmailAddress
        Password = (ConvertTo-SecureString "YourPassword" -AsPlainText -Force)
        Alias = $user.Alias
        DisplayName = $user.DisplayName
    }

    New-MailUser @userParams
}

#Disconnect-ExchangeOnline