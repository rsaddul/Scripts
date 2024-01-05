#region Startup
############### SharePoint Sync Script Adapted by Rhys Saddul
# Clear the PowerShell console.
Clear-Host

# Delay script by 90 seconds to allow AD device to initiate OneDrive client app.
Start-Sleep 90

# Display a header message.
Write-Host "HCUC SharePoint Library Sync" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Yellow
"`n"
#endregion

# Check if OneDrive is configured for the user's documents folder.
$CheckUserDocs = (Get-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal").Personal

# Only proceed with the script if the user's documents folder is redirected to OneDrive.
If ($CheckUserDocs -like '*\OneDrive*\Documents') 
{
    #region Functions

    # Define the Sync-SharepointLocation function.
    function Sync-SharepointLocation {

        param (
            [guid]$siteId,
            [guid]$webId,
            [guid]$listId,
            [mailaddress]$userEmail,
            [string]$webUrl,
            [string]$webTitle,
            [string]$listTitle,
            [string]$syncPath
        )

        try {
            # Load the necessary assembly.
            Add-Type -AssemblyName System.Web

            # Encode site, web, list, URL & email.
            [string]$siteId = [System.Web.HttpUtility]::UrlEncode($siteId)
            [string]$webId = [System.Web.HttpUtility]::UrlEncode($webId)
            [string]$listId = [System.Web.HttpUtility]::UrlEncode($listId)
            [string]$userEmail = [System.Web.HttpUtility]::UrlEncode($userEmail)
            [string]$webUrl = [System.Web.HttpUtility]::UrlEncode($webUrl)

            # Build the URI.
            $uri = New-Object System.UriBuilder
            $uri.Scheme = "odopen"
            $uri.Host = "sync"
            $uri.Query = "siteId=$siteId&webId=$webId&listId=$listId&userEmail=$userEmail&webUrl=$webUrl&listTitle=$listTitle&webTitle=$webTitle"

            # Launch the process from URI.
            start-process -filepath $($uri.ToString())

        }

        catch {
            $errorMsg = $_.Exception.Message
        }

        if ($errorMsg) {
            # Display a sync error message.
            Write-Warning "Sync failed"
            Write-Warning $errorMsg
        }
        else {
            # Display a success message if sync starts.
            Write-Host "Sync process started"
            return $true
        }     
    }

    #endregion 

    #region Infrastructure

    try {
        #region SharePoint Sync

        # Get the user's UPN (User Principal Name).
        [mailaddress]$userUpn = cmd /c "whoami/upn"

        $params = @{
            # Replace with data captured from your SharePoint site.
            siteId    = "{852f3e3e-78b5-49ad-9075-7a3f537dbd35}"
            webId     = "{092c2be1-1e75-4863-acbc-a02a04e95e3b}"
            listId    = "{fea3d0c7-04ee-4ffa-9961-54a92c1e6b08}"
            userEmail = $userUpn
            webUrl    = "https://uxbridgecollegeacuk.sharepoint.com/sites/HRUC-Payroll/"
            webTitle  = "HRUC-Payroll"
            listTitle = "Payroll"
        }

        $params.syncPath  = "$(split-path $env:OneDriveCommercial)\HCUC\$($params.webTitle) - $($Params.listTitle)"

        # Display information about the SharePoint library being synchronised.
        Write-Host "Syncing Resources folder" 
        Write-Host "------------------------"
        Write-Host "Library address:    $($params.weburl)"
        Write-Host "Syncing to folder:  $($params.webTitle) - $($params.listTitle)"

        if (!(Test-Path $($params.syncPath))) {
            # If the SharePoint folder doesn't exist locally, start the sync.
            Write-Host "SharePoint folder not found locally, will now sync.." -ForegroundColor Yellow
            $sp = Sync-SharepointLocation @params

            if (!($sp)) {
                # If sync fails, throw an error.
                Throw "SharePoint sync failed"
            }
        }
        else {
            # If the SharePoint folder already exists locally, display a message.
            Write-Host "Location already synchronised: $($params.syncPath)" -ForegroundColor Yellow
        }

        #endregion
    }
    catch {
        $errorMsg = $_.Exception.Message
    }
    finally {
        if ($errorMsg) {
            # Handle any errors and throw an exception.
            Write-Warning $errorMsg
            Throw $errorMsg
        }
        else {
            # Display a waiting message.
            Write-Host "Waiting to complete..."
        }
    }
    Start-Sleep 15
    Write-Host "Completed"
    "`n"
    #endregion
}
else {
    # Display a message if OneDrive is not properly configured.
    Write-Host "OneDrive is not properly configured for this user's documents folder."
}
