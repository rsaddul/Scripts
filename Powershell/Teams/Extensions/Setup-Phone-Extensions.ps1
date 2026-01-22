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

$HHHW = "+44208909" # Harrow on the Hill & Harrow Weald Phone Number Prefix
$UXHAY = "+44189585" # Uxbridge & Hayes Phone Number Prefix
$RICHMOND = "+44208607"  # Richmond's Phone Number Prefix

Write-Host "Uxbridge Range 1: 01895320758 - 01895320758" -ForegroundColor Green
Write-Host "Uxbridge Range 200: 01895471001 - 01895471200" -ForegroundColor Green
Write-Host "Uxbridge Range 1: 01895471357 - 01895471357" -ForegroundColor Green
Write-Host "Uxbridge Range 300: 01895475201 - 01895475500" -ForegroundColor Green
Write-Host "Uxbridge Range 501: 01895853300 - 01895853800" -ForegroundColor Green
Write-Host "Harrow Weald / Harrow on the Weald Range 657: 02089096011 - 02089096668" -ForegroundColor Red
Write-Host "Richmond Range 500: 02086078000 - 02086078499" -ForegroundColor Yellow
Write-Host "Uxbridge / Hayes Range 1: 01895320759 - 01895320759" -ForegroundColor Green


$User = Read-Host "Please enter staff member's email address"
$Extension = Read-Host "Please enter staff member's extension number"

$Title = "Select User Location"
$choices = '&Uxbridge / Hayes', '&Harrow on the Hill / Harrow Weald', '&Richmond'
$decision = $Host.UI.PromptForChoice($Title, "Pick Site:", $choices, 1)

if ($decision -eq 0) {
    Write-Host 'Setting staff member up for Uxbridge / Hayes' -ForegroundColor Green
    $PhoneNumber = "$UXHAY$Extension"
}
elseif ($decision -eq 1) {
    Write-Host 'Setting staff member up for Harrowon on the Hill / Harrow Weald' -ForegroundColor Red
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


