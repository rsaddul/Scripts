#Config Variables
$SiteURL = "https://uxbridgecollegeacuk.sharepoint.com/sites/HA-Portal/"
$CSVFile = "C:\Users\rsaddul\OneDrive - HCUC\Documents\New_Portal.csv"
 
Try {
    #Connect to PnP Online
    Connect-PnPOnline -Url $SiteURL -Interactive
 
    #Get the CSV file
    $CSVData = Import-CSV $CSVFile
  
    #Read CSV file and grant folder permissions
    ForEach($Row in $CSVData)
    {
        Try {
            #Get the Folder
            $Folder = Get-PnPFolder -Url $Row.FolderServerRelativeURL -Includes ListItemAllFields.ParentList -ErrorAction Stop
            $List =  $Folder.ListItemAllFields.ParentList
            #Get Users
            $Users =  $Row.Users -split ";"
            ForEach($User in $Users)
            {
                #Grant Permission to the Folder
                Set-PnPFolderPermission -List $List -Identity $Folder.ServerRelativeUrl -User $User.Trim() -AddRole $Row.Permission -ErrorAction Stop
                Write-host -f Green "Ensured Permissions on Folder '$($Row.FolderServerRelativeURL)' to '$($User.Trim())'"
            }
        }
        Catch {
            Write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
        }
    }
}
Catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}


#Read more: https://www.sharepointdiary.com/2021/01/sharepoint-online-grant-folder-permissions-from-csv-using-powershell.html#ixzz7fc8W0mFq