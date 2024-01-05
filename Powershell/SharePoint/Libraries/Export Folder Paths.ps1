#Config Variables
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/HA-Portal"
$ListName = "Science IT  Media"
   
Try {
    #Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -Interactive
   
    #Get All Folders from the document Library
    $Folders = Get-PnPFolder -List $ListName
      
    Write-host "Total Number of Items in the Folder in the list:" $Folders.Count
 
    #Get Folder/Subfolder details
#$Export =  $Folders | Select Name, TimeCreated, ItemCount, ServerRelativeUrl 
 $Export =  $Folders | Select ServerRelativeUrl

}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}

$Export  | Out-File "C:\Test.csv"
