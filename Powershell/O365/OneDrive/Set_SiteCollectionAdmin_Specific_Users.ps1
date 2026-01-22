# Developed by <Your Name>
# -------------------------
#Set Runtime Parameters
$AdminSiteURL = "https://eduthingazurelab-admin.sharepoint.com"
$CSVPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Set_SiteCollectionAdmin_Specific_Users.csv"
$clientId = "0a2e4081-bb3a-45a2-b63d-a5abe8657965"

# Connect to SharePoint Admin
Connect-PnPOnline -Url $AdminSiteURL -Interactive -ClientId $clientId

# Import CSV
$Records = Import-Csv -Path $CSVPath

foreach ($Row in $Records) {

    $OneDriveSiteUrl = $Row.OneDriveSiteUrl
    $SiteCollAdmin   = $Row.SiteCollAdmin
    $GlobalAdmin     = $Row.GlobalAdmin    # NEW FIELD

    Write-Host "`nProcessing: $OneDriveSiteUrl" -ForegroundColor Cyan
    Write-Host "Setting owners: $GlobalAdmin, $SiteCollAdmin" -ForegroundColor Yellow

    # Build an array of owners (you can add more fields if needed)
    $Owners = @()

    if ($GlobalAdmin)   { $Owners += $GlobalAdmin }
    if ($SiteCollAdmin) { $Owners += $SiteCollAdmin }

    # Update OneDrive owners
    Set-PnPTenantSite -Url $OneDriveSiteUrl -Owners $Owners

    Write-Host "Updated ownership for $OneDriveSiteUrl" -ForegroundColor Green
}

disconnect-PnPOnline