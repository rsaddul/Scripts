# Import the Exchange Online module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online (you may need to adjust the parameters)
Connect-ExchangeOnline 

# Now you can use Exchange Online cmdlets
$DGs = Get-DistributionGroup 

# Define the export path for the combined CSV file
$combinedExportPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\Test\AllDistributionGroups_Members.csv"

# Initialize an empty array to store member and group information
$allMembersAndGroups = @()

# Iterate through each distribution group
foreach ($DLList in $DGs) {  
    $DL = $DLList.DisplayName

    # Check if the distribution group exists
    if (Get-DistributionGroup -Identity $DL -ErrorAction SilentlyContinue) {
        # Get the members & select columns
        $members = Get-DistributionGroupMember -Identity $DL | 
            Select-Object DisplayName, PrimarySmtpAddress, ExternalEmailAddress, Alias

        # Add members and group information to the array
        foreach ($member in $members) {
            $memberInfo = [PSCustomObject]@{
                'DistributionGroup' = $DL
                'MemberDisplayName' = $member.DisplayName
                'MemberPrimarySmtpAddress' = $member.PrimarySmtpAddress
                'MemberExternalEmailAddress' = $member.ExternalEmailAddress
                'MemberAlias' = $member.Alias
            }
            $allMembersAndGroups += $memberInfo
        }
    } else {
        Write-Host "Distribution Group '$DL' not found."
    }
}

# Export all members and group information to a single CSV file
$allMembersAndGroups | Export-Csv -Path $combinedExportPath -NoTypeInformation

# Disconnect from Exchange Online session (optional)
# Disconnect-ExchangeOnline -Confirm:$false
