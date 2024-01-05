##############################
# Get Time and Date for logs #
##############################

$Date = Get-Date -Format "HH:mm - MM/dd/yyyy -"


# Harrow On The Hill Devices
$All_HH_Devices = "OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_HH_Desktops = "OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_HH_Mobiles = "OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Classroom_Desktops_SCCM = "OU=Classroom,OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Office_Desktops_SCCM = "OU=Office,OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Teacher_Desktops_SCCM = "OU=Teacher,OU=Desktop,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Mobile_Classroom_SCCM = "OU=Classroom,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Mobile_Office_SCCM = "OU=Office,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Mobile_Teacher_SCCM = "OU=Teacher,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Mobile_Student_Intune = "OU=Student,OU=Intune,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Mobile_Staff_Intune = "OU=Staff,OU=Intune,OU=Mobile,OU=Devices,OU=HH,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"


(Get-ADComputer -Filter * -SearchBase $All_HH_Devices).Count
(Get-ADComputer -Filter * -SearchBase $All_HH_Desktops).Count
(Get-ADComputer -Filter * -SearchBase $All_HH_Mobiles).Count
(Get-ADComputer -Filter * -SearchBase $HH_Classroom_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HH_Office_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HH_Teacher_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HH_Mobile_Classroom_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HH_Mobile_Office_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HH_Mobile_Teacher_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HH_Mobile_Student_Intune).Count
(Get-ADComputer -Filter * -SearchBase $HH_Mobile_Staff_Intune).Count


# Harrow Weald Devices
$All_HW_Devices = "OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_HY_Desktops = "OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_HY_Mobiles = "OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Classroom_Desktops_SCCM = "OU=Classroom,OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Office_Desktops_SCCM = "OU=Office,OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Teacher_Desktops_SCCM = "OU=Teacher,OU=Desktop,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Mobile_Classroom_SCCM = "OU=Classroom,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Mobile_Office_SCCM = "OU=Office,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Mobile_Teacher_SCCM = "OU=Teacher,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Mobile_Student_Intune = "OU=Student,OU=Intune,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Mobile_Staff_Intune = "OU=Staff,OU=Intune,OU=Mobile,OU=Devices,OU=HW,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"


(Get-ADComputer -Filter * -SearchBase $All_HW_Devices).Count
(Get-ADComputer -Filter * -SearchBase $All_HW_Desktops).Count
(Get-ADComputer -Filter * -SearchBase $All_HW_Mobiles).Count
(Get-ADComputer -Filter * -SearchBase $HW_Classroom_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HW_Office_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HW_Teacher_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HW_Mobile_Classroom_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HW_Mobile_Office_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HW_Mobile_Teacher_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HW_Mobile_Student_Intune).Count
(Get-ADComputer -Filter * -SearchBase $HW_Mobile_Staff_Intune).Count



# Hayes Devices
$All_HY_Devices = "OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_HY_Desktops = "OU=Desktop,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_HY_Mobiles = "OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Classroom_Desktops_SCCM = "OU=Classroom,OU=Desktop,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Office_Desktops_SCCM = "OU=Office,OU=Desktop,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Teacher_Desktops_SCCM = "OU=Teacher,OU=Desktop,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Mobile_Classroom_SCCM = "OU=Classroom,OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Mobile_Office_SCCM = "OU=Office,OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Mobile_Teacher_SCCM = "OU=Teacher,OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Mobile_Student_Intune = "OU=Student,OU=Intune,OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Mobile_Staff_Intune = "OU=Staff,OU=Intune,OU=Mobile,OU=Devices,OU=HY,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"


(Get-ADComputer -Filter * -SearchBase $All_HY_Devices).Count
(Get-ADComputer -Filter * -SearchBase $All_HY_Desktops).Count
(Get-ADComputer -Filter * -SearchBase $All_HY_Mobiles).Count
(Get-ADComputer -Filter * -SearchBase $HY_Classroom_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HY_Office_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HY_Teacher_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HY_Mobile_Classroom_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HY_Mobile_Office_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HY_Mobile_Teacher_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $HY_Mobile_Student_Intune).Count
(Get-ADComputer -Filter * -SearchBase $HY_Mobile_Staff_Intune).Count



# Uxbridge Devices
$All_UX_Devices = "OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_UX_Desktops = "OU=Desktop,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$All_UX_Mobiles = "OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Classroom_Desktops_SCCM = "OU=Classroom,OU=Desktop,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Office_Desktops_SCCM = "OU=Office,OU=Desktop,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Teacher_Desktops_SCCM = "OU=Teacher,OU=Desktop,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Mobile_Classroom_SCCM = "OU=Classroom,OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Mobile_Office_SCCM = "OU=Office,OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Mobile_Teacher_SCCM = "OU=Teacher,OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Mobile_Student_Intune = "OU=Student,OU=Intune,OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Mobile_Staff_Intune = "OU=Staff,OU=Intune,OU=Mobile,OU=Devices,OU=UX,OU=Sites,OU=HCUC V2 (TEST),DC=resource,DC=uc"


(Get-ADComputer -Filter * -SearchBase $All_UX_Devices).Count
(Get-ADComputer -Filter * -SearchBase $All_UX_Desktops).Count
(Get-ADComputer -Filter * -SearchBase $All_UX_Mobiles).Count
(Get-ADComputer -Filter * -SearchBase $UX_Classroom_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $UX_Office_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $UX_Teacher_Desktops_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $UX_Mobile_Classroom_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $UX_Mobile_Office_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $UX_Mobile_Teacher_SCCM).Count
(Get-ADComputer -Filter * -SearchBase $UX_Mobile_Student_Intune).Count
(Get-ADComputer -Filter * -SearchBase $UX_Mobile_Staff_Intune).Count


# Servers
$Domain_Controllers = "OU=Domain Controllers,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HCUC_Azure_Servers = "OU=HCUC-Azure,OU=Servers,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HH_Servers = "OU=HH,OU=Servers,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HW_Servers = "OU=HW,OU=Servers,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$HY_Servers = "OU=HY,OU=Servers,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$UX_Servers = "OU=UX,OU=Servers,OU=HCUC V2 (TEST),DC=resource,DC=uc"
$MIS_Servers = "OU=MIS,OU=Servers,OU=HCUC V2 (TEST),DC=resource,DC=uc"


(Get-ADComputer -Filter * -SearchBase $Domain_Controllers).Count
(Get-ADComputer -Filter * -SearchBase $HCUC_Azure_Servers).Count
(Get-ADComputer -Filter * -SearchBase $HH_Servers).Count
(Get-ADComputer -Filter * -SearchBase $HW_Servers).Count
(Get-ADComputer -Filter * -SearchBase $HY_Servers).Count
(Get-ADComputer -Filter * -SearchBase $UX_Servers).Count
(Get-ADComputer -Filter * -SearchBase $MIS_Servers).Count


