# Developed by Rhys Saddul

# Define the name of the group you want to check
$groupToCheck = "M365 All Trust Staff"

# Define the names of the groups to check against
$groupsToCheckAgainst = @(
    "26 - Teaching Staff",
    "27 - Support Staff",
    "34 - Teaching Staff",
    "35 - Support Staff",
    "42 - Teaching Staff",
    "43 - Support Staff",
    "50 - Teaching Staff",
    "51 - Support Staff",
    "58 - Teaching Staff",
    "59 - Support Staff",
    "66 - Teaching Staff",
    "67 - Support Staff"
)

# Initialize an empty array to store users who are not in any of the specified groups
$usersNotInGroups = @()

# Get the members of the specified group
$groupMembers = Get-ADGroupMember -Identity $groupToCheck

# Loop through each group member and check if they are in any of the specified groups
foreach ($member in $groupMembers) {
    $memberOfAnyGroup = $false
    foreach ($group in $groupsToCheckAgainst) {
        if (Get-ADGroupMember -Identity $group | Where-Object { $_.SamAccountName -eq $member.SamAccountName }) {
            $memberOfAnyGroup = $true
            break
        }
    }

    # If the user is not a member of any of the specified groups, add them to the list
    if (-not $memberOfAnyGroup) {
        $usersNotInGroups += $member.SamAccountName
    }
}

# Create a CSV file with the list of users not in any of the specified groups
$csvPath = "C:\UsersNotInGroups.csv"
$usersNotInGroups | ForEach-Object { [PSCustomObject]@{ "SamAccountName" = $_ } } | Export-Csv -Path $csvPath -NoTypeInformation

# Output a message indicating the completion of the script
Write-Host "Script completed. Users not in any of the specified groups are listed in $csvPath."
