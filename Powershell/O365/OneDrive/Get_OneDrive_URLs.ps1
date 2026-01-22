# ===============================
# Variables
# ===============================
$TenantUrl = "https://instanterlearningtrust-admin.sharepoint.com"
$CSVPath   = "C:\Users\RhysSaddul\Downloads\SMH\Intune_SharePoint\Get_OneDrive_URLs.csv"
$OutputCSV = "C:\Users\RhysSaddul\Downloads\SMH\OneDrive_Audit\FilteredOneDriveSites.csv"

# ===============================
# Import the UPN list from CSV
# Make sure your CSV column is "UserPrincipalName"
# ===============================
$UPNs = Import-Csv -Path $CSVPath

# ===============================
# Connect to SharePoint Online
# ===============================
 Connect-SPOService -Url $TenantUrl

# ===============================
# Get all personal OneDrive sites
# ===============================
$AllSites = Get-SPOSite -IncludePersonalSite $true -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'"

# ===============================
# Match UPNs to OneDrive sites
# ===============================
$Results = foreach ($user in $UPNs) {
    $UPN = $user.UserPrincipalName.Trim()

    $Site = $AllSites | Where-Object { $_.Owner.ToLower() -eq $UPN.ToLower() }

    [PSCustomObject]@{
        UserPrincipalName = $UPN
        OneDriveURL       = if ($Site) { $Site.Url } else { "Not Found" }
    }
}

# ===============================
# Export results to CSV
# ===============================
$Results | Export-Csv -Path $OutputCSV -NoTypeInformation -Force

Write-Host "Done! File saved as $($OutputCSV)."

# ===============================
# Disconnect when finished
# ===============================
# Disconnect-SPOService
