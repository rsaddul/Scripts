$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Student Support.lnk"
$targetPath = "\\azprdapp01\Apps\StudentSupport\Live\TalonESStudentSupport.application"
$startInPath = "\\azprdapp01\Apps\StudentSupport\Live\"
$iconPath = "\\azprdapp01\Apps\Icons\StudentSupport.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\E-Services_Student_Support_Install.txt"
$contents = "This is a temporary text file created for E-Services Enrolments icon installation."

Set-Content -Path $filePath -Value $contents


