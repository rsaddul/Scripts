$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Forms.lnk"
$uninstallFilePath = "$env:APPDATA\E-Forms_Icon_Install.txt"

# Delete the shortcut if it exists
if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
}

# Delete the file if it exists
if (Test-Path $uninstallFilePath) {
    Remove-Item $uninstallFilePath -Force
}
