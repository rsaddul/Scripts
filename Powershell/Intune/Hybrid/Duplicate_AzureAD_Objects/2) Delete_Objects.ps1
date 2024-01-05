# Install AzureAD module if not already installed
if (-not (Get-Module -Name AzureAD -ListAvailable)) {
    Install-Module -Name AzureAD -Force -AllowClobber
}

# Connect to Azure AD
Connect-AzureAD

# Path to the CSV file containing ObjectIDs
$csvFilePath = "C:\Path\To\Your\ObjectIDs.csv"

# Read the CSV file
$objectIds = Import-Csv -Path $csvFilePath | ForEach-Object { $_.ObjectId }

# Loop through each ObjectID and remove the corresponding device
foreach ($objectId in $objectIds) {
    Remove-AzureADDevice -ObjectId $objectId
    Write-Host "Device with ObjectID $objectId removed."
}

# Disconnect from Azure AD
Disconnect-AzureAD
