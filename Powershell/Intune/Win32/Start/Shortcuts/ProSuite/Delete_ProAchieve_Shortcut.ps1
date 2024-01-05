$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\ProAchieve.lnk"
$uninstallFilePath = "$env:APPDATA\ProAchieve_Icon_Install.txt"

# Delete the shortcut if it exists
if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
}

# Delete the file if it exists
if (Test-Path $uninstallFilePath) {
    Remove-Item $uninstallFilePath -Force
}
