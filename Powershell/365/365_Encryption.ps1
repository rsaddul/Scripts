# Check correct Powershell version being used
$varSetupResponse = [System.Windows.Forms.MessageBox]::Show("Are you using Powershell? The AIP module is not support in ISE or Powershell 7.2 etc", "Variable Setup", "YesNo", "Question")

if ($varSetupResponse -eq "Yes") {
    Write-Host "Correct Powershell version being used" -ForegroundColor Green
} else {
    Write-Host "Please set up the variables before proceeding." -ForegroundColor Red
    return  
}

# Check if the variables are set up
$varSetupResponse = [System.Windows.Forms.MessageBox]::Show("Have you set up the variables?", "Variable Setup", "YesNo", "Question")

if ($varSetupResponse -eq "Yes") {
    Write-Host "Variables are set up." -ForegroundColor Green
} else {
    Write-Host "Please set up the variables before proceeding." -ForegroundColor Red
    return 
}

# The AIPService module replaces the older module, AADRM. If you have the older module installed, uninstall it and then install the AIPService module.
# Check if the module AADRM is installed

if (Get-Module -Name AADRM -ListAvailable) {
    # Uninstall the module AADRM
    Uninstall-Module -Name AADRM -Force
    Write-Host "AADRM module has been uninstalled."
} else {
    Write-Host "AADRM module is not installed."
}

# Install the AIPService module from the PowerShell Gallery
# Check if the module AIPService is installed

if (-not (Get-Module -Name AIPService -ListAvailable)) {
    # Install the module AIPService
    Install-Module -Name AIPService -Force -Scope CurrentUser
    Write-Host "AIPService module has been installed."
} else {
    Write-Host "AIPService module is already installed."
    Update-Module -Name AIPService
}

# Setup Varibles for Onboarding Control Usergroup - please hash out if not being used
$GroupID = "133de3b6-8859-4c0e-b424-c89ff1bb51b6"

# Connect to the AIP service using a web session
Connect-AipService 

# Check if the AIP service is enabled
$aipService = Get-AipService

if (-not $aipService.Enabled) {
    # AIP service is disabled, prompt the user to enable it
    $confirm = Read-Host "The Azure Information Protection service is currently disabled. Do you want to enable it? (Y/N)"

    if ($confirm -eq "Y" -or $confirm -eq "y") {
        # Prompt the user whether to configure onboarding controls for a phased deployment
        $configureOnboarding = Read-Host "Do you want to configure onboarding controls for a phased deployment? (Y/N)"
        if ($configureOnboarding -eq "Y" -or $configureOnboarding -eq "y") {
            # Configure onboarding controls for a phased deployment
            Set-AipServiceOnboardingControlPolicy -UseRmsUserLicense $False -SecurityGroupObjectId $GroupID
            Write-Host "Onboarding controls for a phased deployment have been configured." -ForegroundColor Yellow
        }       
        Enable-AipService
        Write-Host "AIP service has been enabled." -ForegroundColor Green
    } elseif ($confirm -eq "N" -or $confirm -eq "n") {
        # User chose not to configure onboarding controls, proceed with enabling AIP service
        Enable-AipService
        Write-Host "AIP service has been enabled without configuring onboarding controls for a phased deployment." -ForegroundColor Yellow
    } else {
        Write-Host "Invalid input. AIP service remains disabled." -ForegroundColor Red
    }
} else {
    Write-Host "AIP service is already enabled." -ForegroundColor Green
}

# When you no longer need to use onboarding controls, whether you used the group or licensing option, run the below
# Set-AipServiceOnboardingControlPolicy -UseRmsUserLicense $False