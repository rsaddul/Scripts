$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Forms.lnk"
$targetPath = "\\azprdapp01\Apps\E-forms\Live\EForms.application"
$startInPath = "\\azprdapp01\Apps\E-forms\Live\"
$iconPath = "\\azprdapp01\Apps\Icons\E-Forms.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\E-Forms_Icon_Install.txt"
$contents = "This is a temporary text file created for E-Forms icon installation."

Set-Content -Path $filePath -Value $contents


