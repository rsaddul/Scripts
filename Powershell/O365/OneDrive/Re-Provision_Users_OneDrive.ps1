# Base Varibles
$sharePointUrl = "https://instanterlearningtrust-admin.sharepoint.com" # SharePoint Admin URL
$userListPath = "C:\Users\RhysSaddul\Downloads\SMH\Provision.txt" # Define the user list file path
# Example
# user1@contoso.com
# user2@contoso.com
# user3@contoso.com

Add-Type -AssemblyName System.Windows.Forms

# Prompt to ensure security groups have been setup prior to running the script

$Checks = [System.Windows.Forms.MessageBox]::Show("Have you updated the Base Varibles", "Base Varibless", "YesNo", "Question")
if ($Checks -eq "Yes") {
    Write-Host "User confirmed Base Varibles are setup. Proceeding with the script." -ForegroundColor Green
} else {
    Write-Host "User confirmed Base Varibles have not been updated. Exiting the script" -ForegroundColor Red
    return
}

# Double Check
$DoubleCheck = [System.Windows.Forms.MessageBox]::Show("Are you sure about all your answers?", "DoubleCheck", "YesNo", "Question")
if ($DoubleCheck -eq "Yes") {
    Write-Host "User confirmed they are happy . Proceeding with the script." -ForegroundColor Green
} else {
    Write-Host "User confirmed they are unsure and need to check things over" -ForegroundColor Red
    return
}


# Check if the SPO module is installed
if (-not (Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable)) {
    # If not installed, install the module
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
}

# Check if the user list file exists
if (-not (Test-Path -Path $userListPath)) {
    Write-Error "User list file not found at path: $userListPath"
    exit 1
}

if (-not (Get-Module -ListAvailable -Name WriteAscii)) {
    Install-Module WriteAscii -Scope AllUsers -Force
} 

"Cloud Donny" | Write-Ascii -ForegroundColor Rainbow -Compress

# Connect to Microsoft Online Services and SharePoint Online
Connect-SPOService -URL $sharePointUrl

# Request personal sites for the specified users in batches
try {
    $users = Get-Content -Path $userListPath
    $i = 0
    $j = 0
    $count = $users.Count
    $list = @()

    foreach ($u in $users) {
        $i++
        $j++
        Write-Host "$j/$count"

        $upn = $u
        $list += $upn

        if ($i -eq 199) {
            # We reached the limit
            Write-Host "Batch limit reached, requesting provision for the current batch"
            Request-SPOPersonalSite -UserEmails $list -NoWait
            Start-Sleep -Milliseconds 655
            $list = @()
            $i = 0
        }
    }

    if ($i -gt 0) {
        Request-SPOPersonalSite -UserEmails $list -NoWait
    }
    Write-Host "Completed OneDrive Provisioning for $j users" -ForegroundColor Green
} catch {
    Write-Error "Failed to request personal sites. Error: $_"
    exit 1
}