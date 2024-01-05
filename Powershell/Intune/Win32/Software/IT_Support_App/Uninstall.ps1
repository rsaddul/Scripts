# Variables
$folderPath = "C:\HRUC\Scripts\IT_Support"
$startupDestinationPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

# Functions
function Remove-Folder {
    param (
        [string]$folderPath
    )
    
    if (Test-Path -Path $folderPath -PathType Container) {
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Host "Folder removed: $folderPath"
    } else {
        Write-Host "Folder does not exist: $folderPath"
    }
}

function Remove-StartupShortcut {
    param (
        [string]$shortcutPath
    )
    
    if (Test-Path -Path $shortcutPath -PathType Leaf) {
        Remove-Item -Path $shortcutPath -Force
        Write-Host "Shortcut removed: $shortcutPath"
    } else {
        Write-Host "Shortcut not found: $shortcutPath"
    }
}

# Main Script

try {
    Remove-Folder -folderPath $folderPath
    Remove-StartupShortcut -shortcutPath "$startupDestinationPath\HRUC_InfoApp.lnk"
} catch {
    Write-Host "An error occurred: $_"
}
