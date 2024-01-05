#Config Variables
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/UX-Portal"
$CSVFilePath = "C:\UX-ArchiveFolders1.csv"
  
Try {
    #Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -Interactive
 
    #Get the CSV file
    $CSVFile = Import-Csv $CSVFilePath
   
    #Read CSV file and create folders
    ForEach($Row in $CSVFile)
    { 
        #Create Folder if it doesn't exist
        Resolve-PnPFolder -SiteRelativePath $Row.FolderSiteRelativeURL | Out-Null
        Write-host "Ensured Folder:"$Row.FolderSiteRelativeURL -f Green
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}