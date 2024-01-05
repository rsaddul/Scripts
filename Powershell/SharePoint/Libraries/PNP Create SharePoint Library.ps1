#Function to Ensure a SharePoint Online document library
Function EnsurePnP-DocumentLibrary()
{
    param
    (
        [Parameter(Mandatory=$true)] [string] $LibraryName
    )   
    Try {
        Write-host -f Yellow "`nEnsuring Library '$LibraryName'"
          
        #Check if the Library exist already
        $List = Get-PnPList | Where {$_.Title -eq $LibraryName}
        If($List -eq $Null)
        {
            #Create Document Library
            $List = New-PnPList -Title $LibraryName -Template DocumentLibrary -OnQuickLaunch 
            write-host  -f Green "`tNew Document Library '$LibraryName' has been created!"
        }
        Else
        {
            Write-Host -f Magenta "`tA Document Library '$LibraryName' Already exist!"
        }
    }
    Catch {
        write-host -f Red "`tError Creating Document Library!" $_.Exception.Message
    }
}
 
#Connect to SharePoint Online
Connect-PnPOnline "https://uxbridgecollegeacuk.sharepoint.com/sites/Payroll" -Interactive
 
#Call the function to Ensure Document Library
EnsurePnP-DocumentLibrary -LibraryName "Script Created Library"

