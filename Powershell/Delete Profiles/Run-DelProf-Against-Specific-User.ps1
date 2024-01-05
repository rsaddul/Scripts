Clear-Host
Write-Host "GLF DelProf Remote User Target Script" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow
"`n"
Write-Host "This script can be used to remove a specific user profile from one or more devices at a time."
Write-Host "Use a wildcard symbol * in the device name to run against multiple devices at once. e.g. APS-S-*"
Write-Host "NOTE: " -ForegroundColor Red -NoNewline; Write-Host "The account you run this script with must be a local administrator on both the local and remote computers."
"`n"
$Hostname = Read-Host -Prompt "Enter the name of the remote computer you wish to run DelProf on"
$Computers = Get-ADComputer -Filter {Name -like $Hostname}
If ($Computers -eq $null) {Write-Host "No computers could be retrieved from AD that meet your search criteria."; exit 1}
$RetrievedComps = ($Computers | select Name,DNSHostName)
Write-Host "Your search returned the following devices to run DelProf on:"
"`n"
Write-Host "DNS Host Name"
Write-Host "-------------"
ForEach ($RT in $RetrievedComps) {$DNSName = $RT.DNSHostName; Write-Host "$DNSName"}
"`n"
$CompCont = Read-Host "Type (Y)es or (N)o and enter to continue"
$CompCont = $CompCont.ToUpper()
If ($CompCont -eq "Y") {$CompCont = "YES"}
If ($CompCont -ne "YES") {Write-Host "Script stopped by user."; exit 0}
"`n"
$UserToClear = Read-Host "Enter the SamAccountName of the user profile you wish to clear"
$UserCheck = (Get-ADUser -Identity $UserToClear -ErrorAction SilentlyContinue)
If ($UserCheck -eq $null) {Write-Host "The specified user account could not be found within AD. Stopping script."; exit 1}
Write-Host "You search has returned the following user:"
"`n"
$UserName = ($UserCheck.Name)
$UPN = ($UserCheck.UserPrincipalName)
$UserSAM = ($UserCheck.SamAccountName)
Write-Host "Name: $UserName"
Write-Host "UPN:  $UPN"
"`n"
$FinalCont = Read-Host "Type (Y)es or (N)o and enter to continue"
$FinalCont = $FinalCont.ToUpper()
If ($FinalCont -eq "Y") {$FinalCont = "YES"}
If ($FinalCont -ne "YES") {Write-Host "Script stopped by user."; exit 0}

#Check for local copy of delprof is present
If ((Test-Path C:\GLFIT) -eq $false) {md C:\GLFIT ; attrib +s +h C:\GLFIT}
If ((Test-Path C:\GLFIT\DelProf2.exe) -eq $false) {Copy-Item "\\ad.glfschools.org\GLFVOL$\DelProf2\DelProf2.exe" -Destination "C:\GLFIT\DelProf2.exe"}
$runpath = "C:\GLFIT\DelProf2.exe"

#Run Delprof on targeted computers

ForEach ($Computer in $Computers)
{$CurrentComp = $Computer.DNSHostName

Write-Host "Removing profile $UserSAM from computer $CurrentComp..."
#Set arguments for this process
$arguments = "/u /i /c:\\$CurrentComp /id:$UserSAM"

#Run Command
Start-Process -filepath $runpath -ArgumentList $arguments -Wait
Write-Host "Resetting variables before next stage..."
$CurrentComp = ""
$UserCheck = $null
$UserName = $null
$UPN = $null
$arguments = $null
}
"`n"
Write-Host "Process has completed."