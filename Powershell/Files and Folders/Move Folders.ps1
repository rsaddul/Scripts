# Import user profiles from CSV file
$UserProfiles = Import-Csv "C:\TEST.csv"

# Log file path
$LogFilePath = "C:\Log.txt"

# Loop through each user profile and move files from "From" to "To" path
foreach ($UserProfile in $UserProfiles) {

    # Get "From" and "To" path from user profile
    $FromPath = $UserProfile.'From '
    $ToPath = $UserProfile.To

    # Check if "To" path exists
    if (!(Test-Path -Path $ToPath -Force)) {

        # If "To" path does not exist, create it and move the file
        Write-Host "Creating path $ToPath..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $ToPath | Out-Null
        Write-Host "Moving file from $FromPath to $ToPath..." -ForegroundColor Green
        Move-Item -Path $FromPath -Destination $ToPath
        Write-Host "File moved successfully." -ForegroundColor Green

        # Log the action
        $LogMessage = "Moved file from $FromPath to $ToPath."
        $LogMessage | Out-File -FilePath $LogFilePath -Append
    }
    else {
        # If "To" path exists, skip it and log the action
        Write-Host "Path $ToPath already exists." -ForegroundColor Yellow
        $LogMessage = "Skipped path $ToPath because it already exists."
        $LogMessage | Out-File -FilePath $LogFilePath -Append
    }
}
