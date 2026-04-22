# Teams startup registry path
$teamsStartupKey = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MSTeams_8wekyb3d8bbwe\TeamsTfwStartupTask"

# Desired values
$enabledStartupState = 2
$userApprovedStartup = 1

if (Test-Path $teamsStartupKey) {

    $currentStartupState = Get-ItemPropertyValue -Path $teamsStartupKey -Name "State" -ErrorAction SilentlyContinue

    if (($currentStartupState -eq 0) -or ($currentStartupState -eq 1)) {

        Set-ItemProperty -Path $teamsStartupKey -Name "State" -Value $enabledStartupState -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $teamsStartupKey -Name "UserEnabledStartupOnce" -Value $userApprovedStartup -ErrorAction SilentlyContinue

        Write-Host "Microsoft Teams auto-start has been enabled."

    }
    else {

        Write-Host "Microsoft Teams auto-start is already enabled."

    }

}
else {

    Write-Host "Microsoft Teams startup registry key not found."

}