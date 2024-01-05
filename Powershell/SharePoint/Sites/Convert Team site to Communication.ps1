 
#Parameters
$AdminCenterURL="https://agps-admin.sharepoint.com/"
$SiteURL = "https://agps.sharepoint.com/"
 
#Connect to SharePoint Admin Center
Connect-PnPOnline -Url $SiteURL -UseWebLogin

Enable-PnPCommSite