$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\ProAchieve.lnk"
$targetPath = "\\ux-proapp-01\ProSuite$\ProAchieve\ProAchieveExecutor.exe"
$startInPath = "\\ux-proapp-01\ProSuite$\ProAchieve\"
$iconPath = "\\ux-proapp-01\ProSuite$\Icons\ProAchieve.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\ProAchieve_Icon_Install.txt"
$contents = "This is a temporary text file created for ProAchieve icon installation."

Set-Content -Path $filePath -Value $contents


