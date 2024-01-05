##########################
# Developed by Rhys Saddul
##########################

# Function to check and install MicrosoftTeams module
function Install-TeamsModule {
    $Module = Get-Module -Name MicrosoftTeams -ErrorAction SilentlyContinue
    $Version = Get-InstalledModule -Name MicrosoftTeams -ErrorAction SilentlyContinue | Where-Object {$_.Version -ge "4.6.0"}

    if (-not $Module -and -not $Version) {
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

    $HHHW = "+44208909"
    $UXHAY = "+44189585"
    $RICHMOND = "+44208607"  # Richmond's phone number prefix

    $User = Read-Host "Please enter staff member's email address"

    $Title = "Select User Location"
    $choices = '&Uxbridge / Hayes', '&Harrow on the Hill / Harrow Weald', '&Richmond'
    $decision = $Host.UI.PromptForChoice($Title, "Pick Site:", $choices, 1)

    if ($decision -eq 0) {
        Write-Host 'Setting staff member up for Uxbridge / Hayes' -ForegroundColor Green
        $PhoneNumber = "$UXHAY$Extension"
    }
    elseif ($decision -eq 1) {
        Write-Host 'Setting staff member up for Harrow on the Hill / Harrow Weald' -ForegroundColor Red
        $PhoneNumber = "$HHHW$Extension"
    }
    else {
        Write-Host 'Setting staff member up for Richmond' -ForegroundColor Yellow
        $PhoneNumber = "$RICHMOND$Extension"
    }

    # Assign Extension To User
    Set-CsPhoneNumberAssignment -Identity $User -PhoneNumber $PhoneNumber -PhoneNumberType DirectRouting -ErrorAction Stop 

    # Assign Policy To User
    Grant-CsOnlineVoiceRoutingPolicy -Identity $User -PolicyName UK-only
}
