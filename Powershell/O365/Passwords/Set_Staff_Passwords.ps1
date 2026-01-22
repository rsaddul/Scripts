# Check if AzureAD module is installed
if (-not (Get-Module -Name AzureAD -ListAvailable)) {
    Write-Host "AzureAd module is not installed. Please install the module before proceeding." -ForegroundColor Red
    exit
}

# Import necessary module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Initialize progress bar parameters
$ProgressParams = @{
    Activity = "Resetting Office 365 User Passwords"
    Status = "Starting..."
    PercentComplete = 0
}

# Get the list of CSV files in the Downloads folder and allow user to select one
$CSV = Get-ChildItem -Path "C:\Users\RhysSaddul\Downloads\" -Filter *.csv -File | Out-GridView -PassThru

# Check if a CSV was selected
if ($CSV -ne $null) {
    # Import selected CSV file into $Users
    $Users = Import-Csv $CSV.FullName

    # Display the imported CSV data in a grid view and allow selection
    $SelectedUsers = $Users | Out-GridView -PassThru

    # Check if any users were selected
    if ($SelectedUsers -ne $null) {
        # Iterate through each selected user and reset their password
        For ($i = 0; $i -lt $SelectedUsers.Count; $i++) {
            $User = $SelectedUsers[$i]

            Try {
                # Set the new password and set force change password at next login flag
                $SecurePassword = ConvertTo-SecureString $User.Password -AsPlainText -Force

                # Get the user object using the UserPrincipalName
                $AzureADUser = Get-AzureADUser -Filter "UserPrincipalName eq '$($User.UserPrincipalName)'"

                if ($AzureADUser) {
                    Set-AzureADUserPassword -ObjectId $AzureADUser.ObjectId -Password $SecurePassword -ForceChangePasswordNextLogin $false
                    Write-Host -ForegroundColor Green "Password reset completed for $($User.UserPrincipalName)"
                } else {
                    Write-Host -ForegroundColor Red "User not found: $($User.UserPrincipalName)"
                }
            }
            Catch {
                Write-Host -ForegroundColor Red "Failed to reset password for $($User.UserPrincipalName): $_"
            }
            Finally {
                # Update progress bar
                $ProgressParams.Status = "Processing $($User.UserPrincipalName)"
                $ProgressParams.PercentComplete = [math]::Round((($i + 1) / $SelectedUsers.Count) * 100)
                Write-Progress @ProgressParams
            }
            # Introduce a slight delay between operations
            Start-Sleep -Milliseconds 100
        }

        # Complete progress
        $ProgressParams.Status = "Completed"
        $ProgressParams.PercentComplete = 100
        Write-Progress @ProgressParams -Completed

        Write-Host -ForegroundColor Cyan "Password reset process complete!"
    } else {
        Write-Host -ForegroundColor Yellow "No users selected. Exiting script."
    }
} else {
    Write-Host -ForegroundColor Yellow "No CSV file selected. Exiting script."
}