# Distribution Group Name
$GroupName = Read-Host "Please specify the Distribution Group Name"

# Get members of distribution group
$Members = Get-DistributionGroupMember -Identity $GroupName

# Create an empty array to store user information
$UserInfo = @()

# Iterate through each member and retrieve user attributes
ForEach ($Member in $Members) {
    $User = Get-User -Identity $Member.PrimarySmtpAddress
    $UserObject = New-Object PSObject -Property @{
        "DisplayName" = $User.DisplayName
        "EmailAddress" = $User.PrimarySmtpAddress
        "Department" = $User.Department
        # Add more properties if required
    }
    $UserInfo += $UserObject
}

# Export the user information to a CSV file
$UserInfo | Export-Csv -path "C:\Users.csv" -NoTypeInformation