# Specify the path to the CSV file
$csvPath = "C:\Users\rsaddul\Downloads\G.csv"

# Specify the path to the output CSV file
$outputCsvPath = "C:\Users\rsaddul\Downloads\DisabledUsers.csv"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Create an array to store disabled users
$disabledUsers = @()

# Loop through each user in the CSV
foreach ($user in $users) {
    # Get the samAccountName from the CSV
    $samAccountName = $user.samAccountName

    # Check if the user account is disabled
    $disabled = Get-ADUser -Filter "samAccountName -eq '$samAccountName'" | Select-Object -ExpandProperty Enabled

    # If the user is disabled, add it to the array
    if (-not $disabled) {
        $disabledUsers += $user
    }
}

# Export the disabled users to a CSV file
$disabledUsers | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Host "Disabled users exported to $outputCsvPath."
