##########################
# Developed by Rhys Saddul
##########################

# Function to check and install MicrosoftTeams module
function Install-TeamsModule {
    $Module = Get-Module -Name MicrosoftTeams -ErrorAction SilentlyContinue
    $Version = Get-InstalledModule -Name MicrosoftTeams -ErrorAction SilentlyContinue | Where-Object {$_.Version -ge "4.6.0"}

    if (-not $Module) {
        Write-Host "MicrosoftTeams module not installed, attempting to install/update module" -ForegroundColor Red
        Install-Module MicrosoftTeams -Force -AllowClobber
    }
    else {
        Write-Host "MicrosoftTeams module is installed" -ForegroundColor Green
    }
}

# Main script
Install-TeamsModule

# Connect to Microsoft Teams
Connect-MicrosoftTeams

# Get staff member's extension number
$Extension = Read-Host "Please enter staff member's extension number"

# Check if Extension Number Exists
Write-Host "Checking if Extension Number $Extension Exists" -ForegroundColor Green
$URI = Get-CsOnlineUser -Filter { LineURI -ne $null } | Select-Object DisplayName, UserPrincipalName, LineURI

$ExtensionInUse = $false

foreach ($Member in $URI) {
    if ($Member.LineURI -like "*$Extension") {
        $Name = $Member.DisplayName
        Write-Warning "$Extension is in use by $Name"
        $ExtensionInUse = $true
        break  # Exit the loop after finding the extension in use
    }
}

if (-not $ExtensionInUse) {
    Write-Host "$Extension is not in use" -ForegroundColor Green
}
