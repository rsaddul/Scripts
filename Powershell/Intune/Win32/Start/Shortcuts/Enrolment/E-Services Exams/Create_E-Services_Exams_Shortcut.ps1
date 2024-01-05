$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Exams.lnk"
$targetPath = "\\azprdapp01\Apps\Exams\live\TalonESExams.application"
$startInPath = "\\azprdapp01\Apps\Exams\Live\"
$iconPath = "\\azprdapp01\Apps\Icons\Exams.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\E-Services_Exams_Install.txt"
$contents = "This is a temporary text file created for E-Services Enrolments icon installation."

Set-Content -Path $filePath -Value $contents


