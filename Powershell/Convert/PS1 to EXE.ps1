# Check if the PS2EXE module is installed
if (-not (Get-InstalledModule -Name PS2EXE)) {
    # Install the PS2EXE module
    Install-Module -Name PS2EXE -Scope CurrentUser
    Write-Host "The PS2EXE module has been installed." -ForegroundColor Red
} else {
    Write-Host "The PS2EXE module is already installed." -ForegroundColor Green
}

# Prompt the user for the directory path
$directoryPath = Read-Host "Enter the directory path to change to"
CD $directoryPath
# Run the below with with ps1 name to conver to exe

PS2EXE .\Update PSI Secure Browser