#Set Parameters
$SiteURL = "https://crescent.sharepoint.com/sites/Projects"
$ListName = "Inventory"
 
#Connect to SharePoint Online site
Connect-PnPOnline -Url $SiteURL -Interactive
 
#Disable delete in sharepoint online document library
$List = Get-PnPList -Identity $ListName -Includes AllowDeletion
$List.AllowDeletion = $False
$List.Update()
Invoke-PnPQuery


#Read more: https://www.sharepointdiary.com/2019/05/sharepoint-online-disable-delete-in-list.html#ixzz7d5UxDUqd