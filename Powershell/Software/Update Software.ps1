############################
#Get Time and Date for logs#
############################

$Date = Get-Date -Format "HH:mm - MM/dd/yyyy -"

##############
#Architecture#
##############

$86 = ${env:ProgramFiles(x86)}
$64 = $env:ProgramFiles

##############################
#Old File Location On Device #
##############################

$Old = (Get-Command "$64\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue).FileVersionInfo.ProductVersion       

###########################
#New Update File Location #
###########################

$New = (Get-Command "C:\Users\rsaddul\Downloads\npp.8.4.4.Installer.x64").FileVersionInfo.ProductVersion         

#################################################
#Directory Where Software Resides Once Installed#
#################################################

$Path = "C:\Program Files\Notepad++\"

###############################
#Software File To Be Installed#
###############################

$Software = "C:\Users\rsaddul\Downloads\npp.8.4.4.Installer.x64.exe"

####################################################################
#If $New Is Less Than $Old Than Update The Software On The Computer#
####################################################################

####################################################
#Check to see if folder paths exist on the computer#
####################################################

$Check = Test-Path -Path $Path


If (($Old -lt $New) -or (-not $Check)) {            

Write-Host "Version is outdated or does not exist, software will now be updated" -ForegroundColor Red

###########################################################################################
#Sometimes it may be other aruguments such as "Start-Process -FilePath $Software /Q -Wait"#
###########################################################################################

Start-Process -FilePath $Software /S -Wait


###############################################
#Logs for which computers software was updated#
###############################################

"$Date Software installed on $ENV:COMPUTERNAME" | Out-File "C:\Outdated.txt" -Append        

} 
Else {            

Write-Host "Version is up-to-date on $ENV:COMPUTERNAME" -ForegroundColor Green  

}


