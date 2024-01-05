$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Student Support.lnk"
$uninstallFilePath = "$env:APPDATA\E-Services_Student_Support_Install.txt"


# Delete the shortcut if it exists
if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
}

# Delete the file if it exists
if (Test-Path $uninstallFilePath) {
    Remove-Item $uninstallFilePath -Force
}


