$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\E-Services Attendance Tracking.lnk"
$targetPath = "\\azprdapp01\Apps\AttendanceTracking\Live\TalonESAttendanceTracking.application"
$startInPath = "\\azprdapp01\Apps\AttendanceTracking\Live\"
$iconPath = "\\azprdapp01\Apps\Icons\AttendanceTracking.ico"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.WorkingDirectory = $startInPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$filePath = "$env:APPDATA\E-Services_Attendance_Tracking_Install.txt"
$contents = "This is a temporary text file created for E-Services Attendance Tracking icon installation."

Set-Content -Path $filePath -Value $contents


