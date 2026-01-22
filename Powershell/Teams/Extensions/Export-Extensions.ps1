##########################
#Developed by Rhys Saddul#
##########################

#Checks if MicrosoftTeams exists and install if not
$Module = Get-Module -Name MicrosoftTeams
$Version = Get-installedModule -Name MicrosoftTeams | Where-Object {$_.Version -like "*4.6.0*"}

If (-not $Module) {
Write-Host "MicrosoftTeams module not installed, will now attempt to install/update module" -ForegroundColor Red
Install-Module MicrosoftTeams -Force -AllowClobber
}
Else {
Write-Host "MicrosoftTeams module is installed" -ForegroundColor Green
}

#Connect to Microsoft Teams
Connect-MicrosoftTeams

#Variables
$Path = "C:\Extension_List.csv"
$Title = "Export Extension List?"
$Confirmation = Read-Host "Press Enter:"
$choices  = '&Yes', '&No'


#Yes will export CSV and No will close Powershell
$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
If ($decision -eq 0) {
Get-CsOnlineUser -Filter { (LineURI -ne $null) } | Select-Object DisplayName,UserPrincipalName,LineURI  | Export-Csv -Path $Path -NoTypeInformation
Write-Host "Exported file to $Path "
}
Else {
Write-Warning "Closing Script in 10 seconds"
Start-Sleep -Seconds 10
Exit
}