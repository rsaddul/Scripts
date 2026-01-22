$CSVFile = "C:\Users\RhysSaddul\Downloads\Add_Users_To_Distribtuion_List.csv"

# Connect to Exchange Online
#Connect-ExchangeOnline -ShowBanner:$False

# Import CSV Data
$Users = Import-Csv -Path $CSVFile

# Set the distribution group identity
$DistributionGroup = "EDU All Staff"

# Get current members of the distribution group
$CurrentMembers = Get-DistributionGroupMember -Identity $DistributionGroup
$CurrentMemberEmails = $CurrentMembers.PrimarySmtpAddress

foreach ($User in $Users) {
    $UserEmail = $User.UserPrincipalName

    if ($CurrentMemberEmails -notcontains $UserEmail) {
        try {
            Add-DistributionGroupMember -Identity $DistributionGroup -Member $UserEmail
            Write-Host "Added: $UserEmail"
        }
        catch {
            Write-Warning "Failed to add $($UserPrincipalName): $_"
        }
    }
    else {
        Write-Host "$UserEmail is already a member of $DistributionGroup"
    }
}
