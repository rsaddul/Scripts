$CSVFilePath = "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\Migrations\365\Scripts\DL\Create_Distribtuion_List.csv"

Try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -ShowBanner:$False

    # Import CSV and process each distribution group
    Import-Csv $CSVFilePath | ForEach-Object {
        $groupName = $_.Name
        $groupEmail = $_.Email
        $groupType = $_.Type
        $memberList = $_.Members -split ','

        # Create the Distribution Group
        try {
            New-DistributionGroup -Name $groupName -PrimarySmtpAddress $groupEmail -Type $groupType -ErrorAction Stop
            Write-Host -ForegroundColor Green "✔ Created Distribution List: $groupName"
        }
        catch {
            Write-Host -ForegroundColor Magenta "⚠ Group '$groupName' may already exist or failed to create: $($_.Exception.Message)"
        }

        # Get existing members
        $existingMembers = @()
        try {
            $existingMembers = Get-DistributionGroupMember -Identity $groupName -ErrorAction Stop |
                Select-Object -ExpandProperty PrimarySmtpAddress |
                ForEach-Object { $_.ToLower() }
        }
        catch {
            Write-Host -ForegroundColor Yellow "⚠ Could not get members of ${groupName}: $($_.Exception.Message)"

        }

        # Add new members only if not already present
        foreach ($member in $memberList) {
            $trimmedMember = $member.Trim().ToLower()
            if (-not [string]::IsNullOrWhiteSpace($trimmedMember)) {
                if ($existingMembers -notcontains $trimmedMember) {
                    try {
                        Add-DistributionGroupMember -Identity $groupName -Member $trimmedMember -ErrorAction Stop
                        Write-Host -ForegroundColor Cyan "  ➕ Added member: $trimmedMember"
                    }
                    catch {
                        if ($_.Exception.Message -like "*is already a member*") {
                            Write-Host -ForegroundColor Green "  ⚠ Already a member (ignored): $trimmedMember"
                        }
                        elseif ($_.Exception.Message -like "*Couldn't find object*") {
                            Write-Host -ForegroundColor Yellow "  ⚠ User not found (skipped): $trimmedMember"
                        }
                        else {
                            Write-Host -ForegroundColor Red "  ❌ Unexpected error adding '$trimmedMember': $($_.Exception.Message)"
                        }
                    }
                }
                else {
                    Write-Host -ForegroundColor Green "  ⏭ Already a member (skipped): $trimmedMember"
                }
            }
        }
    }
}
Catch {
    Write-Host -ForegroundColor Red "❌ Fatal script error: $($_.Exception.Message)"
}
