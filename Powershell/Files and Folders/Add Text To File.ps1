Clear-Host
Write-Host "GLF BACS Config Script by Rhys Saddul and David Westbrook"
Write-Host "========================================================="
"`n"
#
# Use the variables section below to update config if required
#
# BACS AD GROUP NAME: Specify the name of the AD group that grants users BACS export access in the syntax "domain\group name"
$BACSADGroup = "GLF\Finance Security - BACS Users"

# BACS FOLDER LOCATION: Specify the root BACS Export folder name on the server with it's FQDN
$BACSRoot = "\\ad.glfschools.org\PSF$\PSF-Files\BACS Export"

# LEGACY LOCATIONS: Use this array variable to add any old locations that need to be updated
# IMPORTANT - THESE LOCATIONS ARE CASE SENSITIVE, MAKE SURE YOU ENTER ENTRIES WITH ACCURATE UPPER AND LOWER CASE AND THIS SCRIPT WILL AUTOMATICALLY CHECK FOR ALL-UPPER AND ALL-LOWER CASE VARIATIONS
$LegacyLocations = @('\\GLF-PSFAPP\PSFDocuments$\BACS Export',
                     '\\GLF-PSFAPP.ad.glfschools.org\PSFDocuments$\BACS Export',
                     '\\GLF-PSF-APP01\PSFDocuments$\BACS Export',
                     '\\GLF-PSF-APP01.ad.glfschools.org\PSFDocuments$\BACS Export'
                     )
# IT ADMIN LOG LOCATION: Specify the location of the log file on the server for IT monitoring
$AdminLog = "\\ad.glfschools.org\PSF$\PSF-Files\BACS Export\IT-Logs\BACS-ErrorLog.txt"

# This process adds an upper and lower case value for every LegacyLocation to prevent issues due to the case sensitivity of the .Replace method
ForEach ($DefinedLegacyLocation in $LegacyLocations) {
        $DefinedUpper = $DefinedLegacyLocation.ToUpper()
        $DefinedLower = $DefinedLegacyLocation.ToLower()
        $LegacyLocations += $DefinedUpper
        $LegacyLocations += $DefinedLower
        }

# Get the date and time for logging
$Date = Get-Date -Format "dd-MM-yyyy"
$Time = Get-Date -Format "HH:mm:ss"
$FileTime = Get-Date -Format "HHmm"

# Retrieve the current user's SamAccountName / NT username
$CurrentUser = $env:USERNAME

# Retrie the current user's details
$CurrentUserDetails = [Security.Principal.WindowsIdentity]::GetCurrent()

# Get the full domain\username for use in logging
$FullUsername = $CurrentUserDetails.Name

# Get the current user's AppData folder location
$UserAppData = $env:APPDATA

# Only perform the following checks and config if the user account is a member of the AD.GLFSCHOOLS.ORG domain
$UserDomain = $env:USERDOMAIN
If ($UserDomain -ne "GLF") {
    Write-Host "User is not a member of the GLF Active Directory domain. Skipping checks."
    }
else
{
# Extract the group names that the user is a member of
$CurrentGroups = $CurrentUserDetails.Groups | foreach-object {
    $_.Translate([Security.Principal.NTAccount])
}
# Only perform the BACS checks if the user is a member of the BACS Users AD group
if ($CurrentGroups -notcontains $BACSADGroup) {
    Write-Host "Current user is not set as a BACS user. No configuration required."
    Write-Host "BACS users are configured via AD Group membership."
    Write-Host "Documentation is available for IT staff on the IT Knowledgebase." -ForegroundColor Yellow
    }
else
{
    # Create the correct folder location variable for the current user
    $UserBACSFolder = ($BACSRoot + "\" + $CurrentUser)

    # Perform checks on the server to see if a user folder has been created
    $FolderCheck = Test-Path -Path "$UserBACSFolder"

    # If the folder does not exist then log the issue and exit
    If ($FolderCheck -eq $false) {

        # Create logging output
        $FolderCheckFail = "$Date $Time ERROR: The user $FullUsername is a member of the BACS AD group, but there is no BACS export folder created on the server for them."

        # Log this error on the server for monitoring
        $FolderCheckFail | Out-File $AdminLog -Append -Encoding ascii
        exit 0
        }

    # Check if user has write permission to this folder by creating a test text file
    $TestFileContent = "This is a test file that is used to check if a user has write permissions to their BACS folder. If this file has not been automatically deleted, it can be removed without any harm."
    $TestFileName = $UserBACSFolder + "\" + "$Date-$FileTime-BACSTest.txt"
    $TestFileContent | Out-File $TestFileName

    # Check that the test file exists
    $FolderPermCheck = Test-Path $TestFileName

    # If the test file does not exist log the error and exit
    If ($FolderPermCheck -eq $false) {

        # Create logging output
        $FolderCheckFail = "$Date $Time ERROR: The user $FullUsername is a member of the BACS AD group, but they do not appear to have write permission to the folder $UserBACSFolder."

        # Log this error on the server for monitoring
        $FolderCheckFail | Out-File $AdminLog -Append -Encoding ascii
        exit 0
        }
    else {
        # Remove the test file
        Remove-Item -Path $TestFileName -Force
        }
    # Search the current user's AppData folder for the PSF settings config file
    $PsfINIPath = Get-ChildItem -Path $UserAppData -Recurse -Include PSFIN32*.ini

    # If INI File does not exist, log the error and exit
    If ($PsfINIPath -eq $null) {
        Write-Host "The current user does not have a valid PSF config file in the AppData folder. This can usually be resolved by opening the PS Accounting app."

        # Create logging output
        $INICheckFail = "$Date $Time WARNING: The user $FullUsername is correctly configured for BACS export usage, but they do not have a valid INI config file in their AppData folder, this is usually caused when a user logs into a device for the first time and can be resolved by opening the PS Accounting app (to create the INI) and logging off / on for this process to repeat."

        # Log this error on the server for monitoring
        $INICheckFail | Out-File $AdminLog -Append -Encoding ascii
        exit 0
        }
    else {
    Write-Host "The following PSF config file has been found:"
    Write-Host "$PsfINIPath" -ForegroundColor Yellow
    }
    # Run the config checks against every version of the INI file discovered
    ForEach ($PsfINI in $PsfINIPath) {

        # Set the CurrentINI variable to make life easier
        $CurrentINI = $PsfINI.FullName

        # Check to see if the config file is already setup for BACS
        $CurrentINIBACSReady = Select-String -Path $CurrentINI -Pattern "[BACS]" -SimpleMatch -Quiet

        # If current INI is already setup for BACS, look for the existing legacy config and update
        If ($CurrentINIBACSReady -eq $true) {
            Write-Host "Existing config file has a BACS section already. Updating existing config."
            ForEach ($LegacyLocation in $LegacyLocations) {

                # Retrieve the existing config to see if it contains legacy locations
                $ExistingConf = (Get-Content $CurrentINI) | Select-String -Pattern "[BACS]" -SimpleMatch -Context 0,1

                # Check if any legacy locations are contained in the existing config, only run update if legacy locations are present
                If ($ExistingConf -like "*$LegacyLocation*") {
                    Write-Host "The following existing config lines have been found and will be updated:"
                    Write-Host "$ExistingConf" -ForegroundColor Yellow

                    # Replace the legacy values and output the new config to the original file name
                    (Get-Content $CurrentINI).Replace($LegacyLocation,$BACSRoot) | Set-Content -Path $CurrentINI -Force
                }
                else {
                Write-Host "The existing config does not contain any references to $LegacyLocation"
                }
                }
                }
            else
            {# If INI is not BACS ready, append additional lines onto the end of the existing INI file to configure BACS
            Write-Host "Existing config file does not have a BACS section setup. Adding additional config to the end of the file."
            Add-Content -Path $CurrentINI -Value "[BACS]"

            # Set the new variable to add to the config file
            $NewConfig = "PATH=$UserBACSFolder"
            Add-Content -Path $CurrentINI -Value "$NewConfig"
                }
        "`n"
        $ConfConfirm = (Get-Content $CurrentINI) | Select-String -Pattern "[BACS]" -SimpleMatch -Context 0,1
        Write-Host "The current user's active BACS config is now set as:"
        Write-Host "$ConfConfirm" -ForegroundColor Yellow
        }
    }
}