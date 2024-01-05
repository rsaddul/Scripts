###########################
# Devloped by Rhys Saddul #
###########################

Import-Module ActiveDirectory

#Store CSV into $Movelist variable
$MoveList = Import-Csv -Path "C:\Move Users To OU.csv"
 
#Specify target OU to move users in that CSV file
$TargetOU = "OU=Staff,OU=Users,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
 
#Import the data from CSV file and assign it to variable 
$Imported_csv = Import-Csv -Path "C:\Move Users To OU.csv"
 
$Imported_csv | ForEach-Object {

     # Retrieve Distinguised Name of Users
     $Username = $_.SamAccountName 
     $UserDN  = (Get-ADUser -Identity $Username)

     Write-Host " Moving $Username " -ForegroundColor Green

     # Move user to target OU and Set Logon Script Path Blank
     Move-ADObject  -Identity $UserDN -TargetPath $TargetOU 
     #Set-ADUser -Identity $UserDN -ScriptPath $null
       
      
 }
 Write-Host " Completed move "

 #Count Users
 
 $Number = Import-Csv -Path "C:\Move Users To OU.csv"
 $Total = ($Number).count
 
 Write-Host "$Total user accounts been moved successfully..." -ForegroundColor Green


