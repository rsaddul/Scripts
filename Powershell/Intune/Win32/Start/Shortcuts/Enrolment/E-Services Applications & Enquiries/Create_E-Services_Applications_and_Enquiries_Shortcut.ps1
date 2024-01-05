$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Applications and Enquiries.lnk"
$targetPath = "\\azprdapp01\Apps\Applications\Live\TalonESApplications.application"
$startInPath = "\\azprdapp01\Apps\Applications\Live\"
$iconPath = "\\azprdapp01\Apps\Icons\Applications_and_Enquiries.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\E-Services_Applications_and_Enquiries_Install.txt"
$contents = "This is a temporary text file created for E-Services Applications and Enquiries icon installation."

Set-Content -Path $filePath -Value $contents

