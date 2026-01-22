# Set Runtime Parameters
$AdminSiteURL = "https://eduthingazurelab-admin.sharepoint.com"
$CSVPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Remove_SiteCollectionAdmin_Specific_Users.csv"
$clientId = "0a2e4081-bb3a-45a2-b63d-a5abe8657965"

$Records = Import-Csv -Path $CSVPath

foreach ($Row in $Records) {

    $OneDriveSiteUrl = $Row.OneDriveSiteUrl
    $AdminToRemove   = $Row.SiteCollAdmin

    Write-Host "`nConnecting directly to: $OneDriveSiteUrl" -ForegroundColor Cyan
    Connect-PnPOnline -Url $OneDriveSiteUrl -Interactive -ClientId $clientId

    Write-Host "Removing site collection admin: $AdminToRemove" -ForegroundColor Yellow
    Remove-PnPSiteCollectionAdmin -Owners $AdminToRemove

    Write-Host "Successfully removed $AdminToRemove from $OneDriveSiteUrl" -ForegroundColor Green
}
disconnect-PnPOnline