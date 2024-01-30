# https://learn.microsoft.com/en-us/entra/identity/devices/manage-stale-devices
# Install-Module -Name Microsoft.Graph.Devices
# Import-Module -Name Microsoft.Graph.Devices
# Connect-Graph

# Prompt for confirmation if CSV path is set
$confirmCsvPath = [System.Windows.Forms.MessageBox]::Show("Have you set the CSV file path?", "Confirmation", "YesNo", "Question")
if ($confirmCsvPath -eq "No") {
    Write-Host "Script canceled."
    return
}

# Set export path for CSV file
$csvPath = "C:\devicelist-olderthan-365days-summary.csv"

# Prompt for confirmation if inactiveThreshold variable is set
$confirmInactiveThreshold = [System.Windows.Forms.MessageBox]::Show("Have you set the inactiveThreshold variable?", "Confirmation", "YesNo", "Question")
if ($confirmInactiveThreshold -eq "No") {
    Write-Host "Script canceled."
    return
}

# Calculate the date 90 days ago
$inactiveThreshold = (Get-Date).AddDays(-90)

# Prompt for confirmation if olderThanThreshold variable is set
$confirmOlderThanThreshold = [System.Windows.Forms.MessageBox]::Show("Have you set the olderThanThreshold variable?", "Confirmation", "YesNo", "Question")
if ($confirmOlderThanThreshold -eq "No") {
    Write-Host "Script canceled."
    return
}

# Calculate the date 365 days ago
$olderThanThreshold = (Get-Date).AddDays(-365)

# Retrieve devices that are disabled and inactive for over 90 days
$inactiveDevices = Get-MgDevice -All | 
                   Where-Object { $_.AccountEnabled -eq $false -and $_.ApproximateLastSignInDateTime -le $inactiveThreshold }

# Remove devices that are inactive and disabled for over 90 days
foreach ($device in $inactiveDevices) {
    $DeviceName = $Device.DisplayName
    $DeviceID = $Device.ID
    Write-Host "Removing device $($DeviceName) (ID: $($DeviceID)) as it is inactive and disabled for over $inactiveThreshold days"
    Remove-MgDevice -DeviceId $device.Id
}

# Retrieve devices that have not signed in since the calculated date
$devices = Get-MgDevice -All | 
           Where-Object { $_.ApproximateLastSignInDateTime -le $olderThanThreshold }

# Export the device information to a CSV file
$devices | Export-Csv -Path $csvPath -NoTypeInformation

# Set devices to disabled if last sign-in was over 365 days ago
$params = @{
    accountEnabled = $false
}

foreach ($device in $devices) {
    $DeviceName = $Device.DisplayName
    $DeviceID = $Device.ID
    Write-Host "Updating device $($DeviceName) (ID: $($DeviceID)) to disabled as last sign-in was over $olderThanThreshold days ago"
    Update-MgDevice -DeviceId $device.Id -BodyParameter $params 
}
