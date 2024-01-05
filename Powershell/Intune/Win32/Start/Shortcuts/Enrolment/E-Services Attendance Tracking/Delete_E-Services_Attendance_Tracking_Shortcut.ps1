$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Attendance Tracking.lnk"
$uninstallFilePath = "$env:APPDATA\E-Services_Attendance_Tracking_Install.txt"


# Delete the shortcut if it exists
if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
}

# Delete the file if it exists
if (Test-Path $uninstallFilePath) {
    Remove-Item $uninstallFilePath -Force
}


