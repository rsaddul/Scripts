#region Startup
############### SharePoint Sync Script Adapted by Rhys Saddul
Clear-Host
# Delay script by 90 secs to allow AD device to iniate OneDrive client app
#Start-Sleep 90

Write-Host "HCUC SharePoint Library Sync" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Yellow
"`n"
#endregion

# Put a check in to make sure that OneDrive has completed it's silent config
$CheckUserDocs = (Get-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal").Personal
# Now only run this script if the user's documents folder has been redirected to OneDrive already
If ($CheckUserDocs -like '*\OneDrive*\Documents') 
{
#region Functions 

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

        Add-Type -AssemblyName System.Web 

        #Encode site, web, list, url & email 

        [string]$siteId = [System.Web.HttpUtility]::UrlEncode($siteId) 

        [string]$webId = [System.Web.HttpUtility]::UrlEncode($webId) 

        [string]$listId = [System.Web.HttpUtility]::UrlEncode($listId) 

        [string]$userEmail = [System.Web.HttpUtility]::UrlEncode($userEmail) 

        [string]$webUrl = [System.Web.HttpUtility]::UrlEncode($webUrl) 

        #build the URI 

        $uri = New-Object System.UriBuilder 

        $uri.Scheme = "odopen" 

        $uri.Host = "sync" 

        $uri.Query = "siteId=$siteId&webId=$webId&listId=$listId&userEmail=$userEmail&webUrl=$webUrl&listTitle=$listTitle&webTitle=$webTitle" 

        #launch the process from URI 

        # Write-Host $uri.ToString() 

        start-process -filepath $($uri.ToString()) 

    } 

    catch { 

        $errorMsg = $_.Exception.Message 

    } 

    if ($errorMsg) { 

        Write-Warning "Sync failed" 

        Write-Warning $errorMsg 

    } 

    else { 

        Write-Host "Sync process started" 

        return $true 

    }     

} 


#endregion 
#region Infrastructure 

try { 

    #region Sharepoint Sync 

    [mailaddress]$userUpn = cmd /c "whoami/upn" 

    $params = @{ 

        #replace with data captured from your sharepoint site. 

        siteId    = "{852f3e3e-78b5-49ad-9075-7a3f537dbd35}" 

        webId     = "{092c2be1-1e75-4863-acbc-a02a04e95e3b}" 

        listId    = "{fea3d0c7-04ee-4ffa-9961-54a92c1e6b08}" 

        userEmail = $userUpn 

        webUrl    = "https://uxbridgecollegeacuk.sharepoint.com/sites/HRUC-Payroll/" 

        webTitle  = "HRUC-Payroll" 

        listTitle = "Payroll" 

    } 

    $params.syncPath  = "$(split-path $env:OneDriveCommercial)\HCUC\$($params.webTitle) - $($Params.listTitle)" 

    Write-Host "Syncing Resources folder" 
    Write-Host "------------------------"
    Write-Host "Library address:    $($params.weburl)"
    Write-Host "Syncing to folder:  $($params.webTitle) - $($params.listTitle)"

    if (!(Test-Path $($params.syncPath))) { 

        Write-Host "Sharepoint folder not found locally, will now sync.." -ForegroundColor Yellow 

        $sp = Sync-SharepointLocation @params 

        if (!($sp)) { 

            Throw "Sharepoint sync failed" 

        } 

    } 

    else { 

        Write-Host "Location already synchronised: $($params.syncPath)" -ForegroundColor Yellow 

    } 

    #endregion 

} 

catch { 

    $errorMsg = $_.Exception.Message 

} 

finally { 

    if ($errorMsg) { 

        Write-Warning $errorMsg 

        Throw $errorMsg 

    } 

    else { 

        Write-Host "Waiting to complete..." 

    } 

}
Start-Sleep 15
Write-Host "Completed"
"`n"
#endregion 

