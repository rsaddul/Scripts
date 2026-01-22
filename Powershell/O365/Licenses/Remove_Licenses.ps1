# Developed by: Rhys Saddul

<#

Overview: This script will output a grid for picking your CSV and then output a grid to pick the license you want to unassign.

IMPORTANT: For this to work the users must have a usage location assigned.

#>

# Check if the Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    # If the module is not installed, install it
    Write-Host "Microsoft.Graph module not found. Installing..." -ForegroundColor Red
    Install-Module Microsoft.Graph.Identity.Directory -Scope AllUsers -Repository PSGallery -Force
    Install-Module Microsoft.Graph.Users.Actions -Scope AllUsers -Repository PSGallery -Force
} else {
    # If the module is installed, print a message
    Write-Host "Microsoft.Graph module is already installed." -ForegroundColor Green
}

# Connect to Microsoft Graph with the required scopes
Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All

# Path to CSV file
$CSV = Get-ChildItem -Path "C:\Users\RhysSaddul\Downloads\" -File | Out-GridView -PassThru

# Import CSV of students
$Users = Import-Csv $CSV.FullName

# Get the SKU for licenses
$accountSku = Get-MgSubscribedSku -All | Select-Object SkuPartNumber, SkuID, ConsumedUnits | Out-GridView -PassThru

# Iterate through each student in the CSV
foreach ($User in $Users) {
    # Assign UPN from student data
    $UPN = $User.UserPrincipalName # CSV Column Name

    # Update user license: Remove the specific license ($A1.SkuId)
    try {
        Set-MgUserLicense -UserId $UPN -AddLicenses @() -RemoveLicenses @($accountSku.SkuId)
        Write-Host "Successfully removed license $($accountSku.SkuId) for user $UPN" -ForegroundColor Yellow
    } catch {
        Write-Host "Failed to remove license $($accountSku.SkuId) for user $UPN. Error: $_" -ForegroundColor Red
    }
}

#Disconnect-MgGraph