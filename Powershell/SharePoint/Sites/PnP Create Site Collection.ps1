#Define Variables
$AdminCenterURL = "https://uxbridgecollegeacuk-admin.sharepoint.com/"
$SiteURL = "https://uxbridgecollegeacuk-admin.sharepoint.com/sites/testtt"
$SiteTitle = "Script SharePoint Site"
$SiteOwner = "rsaddul@hcuc.ac.uk"
$Template = "COMMUNITY#0" #Communication Site
$Timezone = 2

Try
{
    #Connect to Tenant Admin
    Connect-PnPOnline -URL $AdminCenterURL -Interactive
     
    #Check if site exists already
    $Site = Get-PnPTenantSite | Where {$_.Url -eq $SiteURL}
 
    If ($Site -eq $null)
    {
        #sharepoint online pnp powershell create site collection
        New-PnPTenantSite -Url $SiteURL -Owner $SiteOwner -Title $SiteTitle -Template $Template -TimeZone $TimeZone -RemoveDeletedSite
        write-host "Site Collection $($SiteURL) Created Successfully!" -foregroundcolor Green
    }
    else
    {
        write-host "Site $($SiteURL) exists already!" -foregroundcolor Yellow
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}

