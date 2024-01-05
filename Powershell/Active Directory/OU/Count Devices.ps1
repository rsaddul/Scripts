##############################
# Get Time and Date for logs #
############################## 

$Date = Get-Date -Format dd-MM-yyyy 

$array = @() 
$object = [PSCustomObject]@{
Name = "Harrow On The Hill"
AllDevices = "OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
AllDesktops = "OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
AllMobiles = "OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMClassroomDesktops = "OU=Classroom,OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMOfficeDesktops = "OU=Office,OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMTeacherDesktops = "OU=Teacher,OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMClassroomMobiles = "OU=Classroom,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMOfficeMobiles = "OU=Office,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMTeacherMobiles = "OU=Teacher,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
IntuneStudentMobiles = "OU=Student,OU=Intune,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
IntuneStaffMobiles = "OU=Staff,OU=Intune,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
}
$array += $object 

$object = [PSCustomObject]@{
#(Get-ADComputer -Filter * -SearchBase "OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc").Count
Name = "Harrow Weald"
AllDevices = "OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
AllDesktops = "OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
AllMobiles = "OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMClassroomDesktops = "OU=Classroom,OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMOfficeDesktops = "OU=Office,OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMTeacherDesktops = "OU=Teacher,OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMClassroomMobiles = "OU=Classroom,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMOfficeMobiles = "OU=Office,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
SCCMTeacherMobiles = "OU=Teacher,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
IntuneStudentMobiles = "OU=Student,OU=Intune,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
IntuneStaffMobiles = "OU=Staff,OU=Intune,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
}

$array += $object 
ForEach ($I in $Array) {
$Name = $I.Name
$AllDevices = $I.AllDevices
$AllDesktops = $I.AllDesktops
$AllMobiles = $I.AllMobiles
$SCCMClassroomDesktops = $I.SCCMClassroomDesktops
$SCCMOfficeDesktops = $I.SCCMOfficeDesktops
$SCCMTeacherDesktops = $I.SCCMTeacherDesktops
$SCCMClassroomMobiles = $I.SCCMClassroomMobiles
$SCCMOfficeMobiles = $I.SCCMOfficeMobiles
$SCCMTeacherMobiles = $I.SCCMTeacherMobiles
$IntuneStudentMobiles = $I.IntuneStudentMobiles
$IntuneStaffMobiles = $I.IntuneStaffMobiles 

Write-Host "Counting All Devices at $Name" -ForegroundColor Green
$AllDevicesCount = (Get-ADComputer -Filter * -SearchBase $AllDevices).Count
$Logs = "$AllDevicesCount Devices at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All Desktops at $Name" -ForegroundColor Green
$AllDesktopsCount = (Get-ADComputer -Filter * -SearchBase $AllDesktops).Count  
$Logs = "$AllDesktopsCount Desktops at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All Mobiles at $Name" -ForegroundColor Green
$AllMobilesCount = (Get-ADComputer -Filter * -SearchBase $AllMobiles).Count  
$Logs = "$AllMobilesCount Mobiles at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All SCCM ClassRoom Desktops at $Name" -ForegroundColor Green
$SCCMClassroomDesktopsCount = (Get-ADComputer -Filter * -SearchBase $SCCMClassroomDesktops).Count
$Logs = "$SCCMClassroomDesktopsCount SCCM ClassRoom Desktops at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All SCCM Office Desktops at $Name" -ForegroundColor Green
$SCCMOfficeDesktopsCount = (Get-ADComputer -Filter * -SearchBase $SCCMOfficeDesktops).Count  
$Logs = "$SCCMOfficeDesktopsCount SCCM Office Desktops at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All SCCM Teacher Desktops at $Name" -ForegroundColor Green
$SCCMTeacherDesktopsCount = (Get-ADComputer -Filter * -SearchBase $SCCMTeacherDesktops).Count 
$Logs = "$SCCMTeacherDesktopsCount SCCM Teacher Desktops at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All SCCM Classroom Mobiles at $Name" -ForegroundColor Green
$SCCMClassroomMobilesCount = (Get-ADComputer -Filter * -SearchBase $SCCMClassroomMobiles).Count
$Logs = "$SCCMClassroomMobilesCount SCCM Classroom Mobiles  at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All SCCM Office Mobiles at $Name" -ForegroundColor Green
$SCCMOfficeMobilesCount = (Get-ADComputer -Filter * -SearchBase $SCCMOfficeMobiles).Count
$Logs = "$SCCMOfficeMobilesCount SCCM Office Mobiles at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All SCCM Teacher Mobiles at $Name" -ForegroundColor Green
$SCCMTeacherMobilesCount = (Get-ADComputer -Filter * -SearchBase $SCCMTeacherMobiles).Count
$Logs = "$SCCMTeacherMobilesCount SCCM Teacher Mobiles at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All Intune Student Mobiles at $Name" -ForegroundColor Green
$IntuneStudentMobilesCount = (Get-ADComputer -Filter * -SearchBase $IntuneStudentMobiles).Count
$Logs = "$IntuneStudentMobilesCount Intune Student Mobiles at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii
 
Write-Host "Counting All Intune Staff Mobiles at $Name" -ForegroundColor Green
$IntuneStaffMobilesCount = (Get-ADComputer -Filter * -SearchBase $IntuneStaffMobiles).Count
$Logs = "$IntuneStaffMobilesCount Intune Staff Mobiles at $Name" | Out-File "C:\logs $Date.txt" -Append -Encoding ascii 
} 