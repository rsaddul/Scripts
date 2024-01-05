$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Enrolments.lnk"
$targetPath = "\\azprdapp01\Apps\Enrolments\Live\TalonESEnrolments.application"
$startInPath = "\\azprdapp01\Apps\Enrolments\LIVE\"
$iconPath = "\\azprdapp01\Apps\Icons\Enrolments.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\E-Services_Enrolments_Install.txt"
$contents = "This is a temporary text file created for E-Services Enrolments icon installation."

Set-Content -Path $filePath -Value $contents


