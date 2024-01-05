# Developed by Rhys Saddul

# Specify the path to the CSV file
$CSV = "C:\Test.csv"

# Define log file paths
$SuccessfulLog = "C:\SuccessfulPasswordChanges.log"
$FailedLog = "C:\FailedPasswordChanges.log"

# Initialize counters for successful and failed password changes
$SuccessfulChanges = 0
$FailedChanges = 0

# Loop through each row in the CSV file
foreach ($User in $Users) {
    $Username = $User.Username
    $NewPassword = $User.Password

    # Check if the user exists (you may need to replace this with your own user lookup logic)
    if (Get-ADUser -Filter {SamAccountName -eq $Username}) {
        try {
            # Set the new password for the user
            Set-ADAccountPassword -Identity $Username -NewPassword (ConvertTo-SecureString -AsPlainText $NewPassword -Force)
            Write-Host "Password for $Username has been set." -ForegroundColor Green
            $SuccessfulChanges++

            # Log successful password changes
            Add-Content -Path $SuccessfulLog -Value "Successful password change for user: $Username"
        } catch {
            Write-Host "Error setting the password for $Username" -ForegroundColor Red
            $FailedChanges++

            # Log failed password changes
            Add-Content -Path $FailedLog -Value "Failed password change for user: $Username"
        }
    } else {
        Write-Host "User $Username does not exist." -ForegroundColor Red
        $FailedChanges++

        # Log failed password changes
        Add-Content -Path $FailedLog -Value "User $Username does not exist."
    }
}

# Display the summary of successful and failed password changes
Write-Host "Successful Password Changes: $SuccessfulChanges" -ForegroundColor Green
Write-Host "Failed Password Changes: $FailedChanges" -ForegroundColor Red
