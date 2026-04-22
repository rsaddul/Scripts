$newTeamsKey = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MSTeams_8wekyb3d8bbwe\TeamsTfwStartupTask"

if (!(Test-Path $newTeamsKey)) {
    Write-Output "New Teams not installed"
    exit 0
}

$state = Get-ItemPropertyValue -Path $newTeamsKey -Name "State" -ErrorAction SilentlyContinue

if ($state -eq 2) {
    Write-Output "New Teams autostart enabled"
    exit 0
}
else {
    Write-Output "New Teams autostart disabled"
    exit 1
}