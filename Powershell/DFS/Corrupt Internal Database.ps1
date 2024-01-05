#Check current state of DFS replicated folders

#CMD - Elevanted rights
#Wmic /namespace:\\root\microsoftdfs path dfsrreplicatedfolderinfo get replicationgroupname,replicatedfoldername,state

#•0: Uninitialized
#•1: Initialized
#•2: Initial Sync
#•3: Auto Recovery
#•4: Normal
#•5: In Error


#Check the EventViewer manually or run the below to find the volume id
#Powershell - Elevanted rights
$EventViewer = "DFS Replication"
$ID = 2104
Get-WinEvent -LogName $EventViewer | Where-Object {$_.ID -eq $ID} | Format-Table -AutoSize -Wrap 

#This will find all latest 10 error logs in DFS Replication Event Viewer
#Get-EventLog -LogName 'DFS Replication' -EntryType Error -Newest 10 | Sort-Object Time,Message | Format-Table -AutoSize -Wrap

#CMD - Elevanted rights
wmic /namespace:\\root\microsoftdfs path dfsrVolumeConfig where volumeGuid="2D5C6F5C-97C4-11E2-93EC-902B34BC5BAB" call ResumeReplication
#DO NOT restart any DFS Service - The rebuild can take several hours


#If the database doesn't re-create succesfully then you will need to run chkdsk /r out of hours
#Ensure backups are inplace before running a CHDKSK /r
#After CHKDSK has run you check the event logs to see if the corrupt database has re-created succesfully 



# IF THE ABOVE FAILS THEN YOU WILL NEED TO FOLLOW THE BELOW INSTRUCTIONS # 


#Powershell - Elevanted rights
#Stop DFSR Service

$ServiceName = "DFSR"
$Service = Get-Service -Name $ServiceName

If ($Service.Status -eq "Running")
{
Stop-Service -Name $ServiceName
Write-Host "The DFSR service has been stopped" -ForegroundColor Black -BackgroundColor Cyan
}
Else
{
Write-Host "Service is already Stopped" -ForegroundColor Black -BackgroundColor Red
}

#Gain access to System Volume Information Folder by disabling the option "Hide protected operating system files"

#CMD - Elevanted rights
#Assign yourself as the directory owner
#Grant your account NTFS permissions

takeown /f "E:\System Volume information"
icacls "E:\System Volume Information" /grant r.saddul.admin:F
icacls "E:\System Volume Information" /grant r.saddul.admin:F /t

#Check in folder permissions if your account has full control permissions


# MAKE SURE TO BACK UP THE DFSR FOLDER INSIDE SYSTEM VOLUME INFORMATION #
# THIS WILL AVOID ANY DATA LOSS #
#Powershell - Elevanted rights

$Path = "E:\System Volume Information\DFSR"
$Destination = "C:\Temp"
$TestA = Test-Path $Path
If ($TestA -eq $true)
{
Write-Host "Copying Directory"
Copy-Item -Path $Path -Destination $Destination -Recurse 
}
else
{
Write-Host "Path Does Not Exist"
}

#Powershell - Elevanted rights
#The below will delete the DFSR folder

$Path = "E:\System Volume Information\DFSR"
$TestA = Test-Path $Path
If ($TestA -eq $true)
{
Write-Host "Removing Directory"
Remove-Item -Path $Path -recurse -force
}
else
{
Write-Host "Path Does Not Exist"
}

#CMD - Elevanted rights
#Restore permissionson on the System Volume Information

icacls "E:\System Volume Information" /setowner "NT Authority\System"
icacls "E:\System Volume Information" /remove r.saddul.admin
icacls "E:\System Volume Information" /remove r.saddul.admin /t

#Powershell - Elevanted rights
#Start DFSR Service

$ServiceName = "DFSR"
$Service = Get-Service -Name $ServiceName

If ($Service.Status -eq "Stopped")
{
Start-Service -Name $ServiceName
Write-Host "The DFSR service has been Started" -ForegroundColor Black -BackgroundColor Cyan
}
Else
{
Write-Host "Service is already Started" -ForegroundColor Black -BackgroundColor Red
}
