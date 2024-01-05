# Check if the Exchange Online module is installed
if (-not (Get-Module -Name ExchangeOnlineManagement -ListAvailable)) {
    Write-Host "Installing Exchange Online module..." -ForegroundColor Yellow

    # Install the Exchange Online module
    Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force
}

# Connect to Exchange Online
Connect-ExchangeOnline

# Prompt the user for the group name, alias, and primary SMTP address
$GroupName = Read-Host "Enter the name for the new mail-enabled security group"
$PrimarySMTP = Read-Host "Enter the primary SMTP address for the group"

# Check if the group already exists in Exchange Online
$existingGroup = Get-DistributionGroup -Filter "Name -eq '$GroupName'"

if ($existingGroup -ne $null) {
    Write-Host "Group '$GroupName' already exists." -ForegroundColor Red
}
else {
    try {
        # Create the mail-enabled security group
        New-DistributionGroup -Name $GroupName -PrimarySmtpAddress $PrimarySMTP -Type Security

        # Import user data from CSV and add them to the group
        $CSVFilePath = "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\test.csv"
        $CSVData = Import-Csv -Path $CSVFilePath

        # Logging 
        $filename = $GroupName
        $LogFolder = "C:\"  # Change this to your desired log folder path

        $FailedUsers = @() 
        $SuccessfulUsers = @()

        foreach ($User in $CSVData) {
            try {
                Add-DistributionGroupMember -Identity $GroupName -Member $User.Username
                Write-Host "User '$($User.Username)' added to '$GroupName'." -ForegroundColor Green
                $SuccessfulUsers += $User.Username
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                Write-Host "Failed to add user '$($User.Username)' to '$GroupName'. Error: $ErrorMessage" -ForegroundColor Red
                $FailedUsers += $User.Username
            }
        }

        Write-Verbose "Writing logs"
        $SuccessfulUsers | Out-File -FilePath "$LogFolder\$filename Success.log" -Force
        $FailedUsers | Out-File -FilePath "$LogFolder\$filename Failed.log" -Force
    }
    catch {
        Write-Host "An error occurred while creating the group: $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        # Disconnect from Exchange Online
        Disconnect-ExchangeOnline -Confirm:$false
    }
}

# End of script
Write-Host "Script execution completed." -ForegroundColor Cyan
