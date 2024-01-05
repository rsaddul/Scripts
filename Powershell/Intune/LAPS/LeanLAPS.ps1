<#
    .DESCRIPTION
    Local Admin Password Rotation and Account Management
    Set configuration values, and follow rollout instructions at https://www.lieben.nu/liebensraum/?p=3605

    Not testing in hybrid scenario's. Should work, but may conflict with e.g. specific password policies.
  
    .NOTES
    filename:               leanLAPS.ps1
    author:                 Jos Lieben (Lieben Consultancy)
    created:                09/06/2021
    last updated:           see Git
    #Copyright/License:     https://www.lieben.nu/liebensraum/commercial-use/ (Commercial (re)use not allowed without prior written consent by the author, otherwise free to use/modify as long as header are kept intact)
    inspired by:            Rudy Ooms; https://call4cloud.nl/2021/05/the-laps-reloaded/
#>

####CONFIG
$minimumPasswordLength = 21
$publicEncryptionKey = "6,2,0,0,0,164,0,0,82,83,65,49,0,8,0,0,1,0,1,0,105,87,187,236,238,172,210,20,99,111,254,19,5,220,72,164,253,36,118,1,174,117,32,24,71,199,60,86,229,104,185,177,136,199,69,221,48,11,218,157,230,179,119,242,30,198,190,32,21,206,51,110,118,3,0,104,71,168,5,59,4,99,77,174,21,124,29,72,249,58,77,224,235,35,79,161,122,64,187,162,44,151,152,146,214,188,250,151,83,239,97,121,63,45,191,79,162,183,133,197,69,228,124,209,212,18,124,32,1,132,228,87,194,173,161,3,122,226,211,45,102,160,34,134,46,247,13,66,63,5,241,118,155,205,19,171,41,192,223,9,59,17,61,97,17,73,85,119,224,244,220,252,70,139,127,186,59,164,52,65,205,77,34,57,221,25,41,36,33,154,94,30,148,2,83,131,19,196,122,236,103,158,128,104,238,196,137,21,162,233,124,241,151,245,57,62,72,74,70,41,56,105,87,122,218,115,238,94,108,110,187,180,83,241,168,253,54,203,174,106,203,177,159,234,200,58,236,197,141,120,230,59,133,149,164,253,51,25,246,162,151,244,255,219,242,212,50,64,164,19,111,223,183,141,124,205" #if you supply a public encryption key, leanLaps will use this to encrypt the password, ensuring it will only be in encrypted form in Proactive Remediations
$localAdminName = 'LCAdmin'
$removeOtherLocalAdmins = $False #if set to True, will remove ALL other local admins, including those set through AzureAD device settings
$disableBuiltinAdminAccount = $False #Disables the built in admin account (which cannot be removed). Usually not needed as most OOBE setups have already done this
$doNotRunOnServers = $True #buildin protection in case an admin accidentally assigns this script to e.g. a domain controller
$markerFile = Join-Path $Env:TEMP -ChildPath "leanLAPS.marker"
$markerFileExists = (Test-Path $markerFile)
$approvedAdmins = @( #specify SID's for Azure groups such as Global Admins and Device Administrators or for local or domain users to not remove from local admins. These are specific to your tenant, you can get them on a device by running: ([ADSI]::new("WinNT://$($env:COMPUTERNAME)/$((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")).Translate([System.Security.Principal.NTAccount]).Value.Split("\")[1]),Group")).Invoke('Members') | % {"$((New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList @([Byte[]](([ADSI]$_).properties.objectSid).Value, 0)).Value) <--- a.k.a: $(([ADSI]$_).Path.Split("/")[-1])"}
#Local Admin
"S-1-5-21-2508976297-1376573969-2727111535-500"

#Domain Admins
"S-1-5-21-2865035389-1569799765-2681417579-512"
)


function Get-RandomCharacters($length, $characters) { 
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length } 
    $private:ofs="" 
    return [String]$characters[$random]
}

function Get-NewPassword($passwordLength){ #minimum 10 characters will always be returned
    $password = Get-RandomCharacters -length ([Math]::Max($passwordLength-6,4)) -characters 'abcdefghiklmnoprstuvwxyz'
    $password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
    $password += Get-RandomCharacters -length 2 -characters '1234567890'
    $password += Get-RandomCharacters -length 2 -characters '!_%&/()=?}][{#*+'
    $characterArray = $password.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}

Function Write-CustomEventLog($Message){
    $EventSource=".LiebenConsultancy"
    if ([System.Diagnostics.EventLog]::Exists('Application') -eq $False -or [System.Diagnostics.EventLog]::SourceExists($EventSource) -eq $False){
        $res = New-EventLog -LogName Application -Source $EventSource  | Out-Null
    }
    $res = Write-EventLog -LogName Application -Source $EventSource -EntryType Information -EventId 1985 -Message $Message
}

Write-CustomEventLog "LeanLAPS starting on $($ENV:COMPUTERNAME) as $($MyInvocation.MyCommand.Name)"

if($doNotRunOnServers -and (Get-WmiObject -Class Win32_OperatingSystem).ProductType -ne 1){
    Write-CustomEventLog "Unsupported OS!"
    Write-Error "Unsupported OS!"
    Exit 0
}

$mode = $MyInvocation.MyCommand.Name.Split(".")[0]
$pwdSet = $false

#when in remediation mode, always exit successfully as we remediated during the detection phase
if($mode -ne "detect"){
    Exit 0
}else{
    #check if marker file present, which means we're in the 2nd detection run where nothing should happen except posting the new password to Intune
    if($markerFileExists){
        $pwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((Get-Content $markerFile | ConvertTo-SecureString)))
        Remove-Item -Path $markerFile -Force -Confirm:$False
        if($publicEncryptionKey.Length -gt 5){
            $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
            $rsa.ImportCspBlob([byte[]]($publicEncryptionKey -split ","))
            $pwd = $rsa.Encrypt([System.Text.Encoding]::UTF8.GetBytes($pwd), $false )
        }else{
            #ensure the plaintext password is removed from Intune log files and registry (which are written after a delay):
            $triggers = @((New-ScheduledTaskTrigger -At (get-date).AddMinutes(5) -Once),(New-ScheduledTaskTrigger -At (get-date).AddMinutes(10) -Once),(New-ScheduledTaskTrigger -At (get-date).AddMinutes(30) -Once))
            $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -EncodedCommand RgB1AG4AYwB0AGkAbwBuACAAVwByAGkAdABlAC0AQwB1AHMAdABvAG0ARQB2AGUAbgB0AEwAbwBnACgAJABNAGUAcwBzAGEAZwBlACkAewAKACAAIAAgACAAJABFAHYAZQBuAHQAUwBvAHUAcgBjAGUAPQAiAC4ATABpAGUAYgBlAG4AQwBvAG4AcwB1AGwAdABhAG4AYwB5ACIACgAgACAAIAAgAGkAZgAgACgAWwBTAHkAcwB0AGUAbQAuAEQAaQBhAGcAbgBvAHMAdABpAGMAcwAuAEUAdgBlAG4AdABMAG8AZwBdADoAOgBFAHgAaQBzAHQAcwAoACcAQQBwAHAAbABpAGMAYQB0AGkAbwBuACcAKQAgAC0AZQBxACAAJABGAGEAbABzAGUAIAAtAG8AcgAgAFsAUwB5AHMAdABlAG0ALgBEAGkAYQBnAG4AbwBzAHQAaQBjAHMALgBFAHYAZQBuAHQATABvAGcAXQA6ADoAUwBvAHUAcgBjAGUARQB4AGkAcwB0AHMAKAAkAEUAdgBlAG4AdABTAG8AdQByAGMAZQApACAALQBlAHEAIAAkAEYAYQBsAHMAZQApAHsACgAgACAAIAAgACAAIAAgACAAJAByAGUAcwAgAD0AIABOAGUAdwAtAEUAdgBlAG4AdABMAG8AZwAgAC0ATABvAGcATgBhAG0AZQAgAEEAcABwAGwAaQBjAGEAdABpAG8AbgAgAC0AUwBvAHUAcgBjAGUAIAAkAEUAdgBlAG4AdABTAG8AdQByAGMAZQAgACAAfAAgAE8AdQB0AC0ATgB1AGwAbAAKACAAIAAgACAAfQAKACAAIAAgACAAJAByAGUAcwAgAD0AIABXAHIAaQB0AGUALQBFAHYAZQBuAHQATABvAGcAIAAtAEwAbwBnAE4AYQBtAGUAIABBAHAAcABsAGkAYwBhAHQAaQBvAG4AIAAtAFMAbwB1AHIAYwBlACAAJABFAHYAZQBuAHQAUwBvAHUAcgBjAGUAIAAtAEUAbgB0AHIAeQBUAHkAcABlACAASQBuAGYAbwByAG0AYQB0AGkAbwBuACAALQBFAHYAZQBuAHQASQBkACAAMQA5ADgANQAgAC0ATQBlAHMAcwBhAGcAZQAgACQATQBlAHMAcwBhAGcAZQAKAH0ACgAKACMAdwBpAHAAZQAgAHAAYQBzAHMAdwBvAHIAZAAgAGYAcgBvAG0AIABsAG8AZwBmAGkAbABlAHMACgB0AHIAeQB7AAoAIAAgACAAIAAkAGkAbgB0AHUAbgBlAEwAbwBnADEAIAA9ACAASgBvAGkAbgAtAFAAYQB0AGgAIAAkAEUAbgB2ADoAUAByAG8AZwByAGEAbQBEAGEAdABhACAALQBjAGgAaQBsAGQAcABhAHQAaAAgACIATQBpAGMAcgBvAHMAbwBmAHQAXABJAG4AdAB1AG4AZQBNAGEAbgBhAGcAZQBtAGUAbgB0AEUAeAB0AGUAbgBzAGkAbwBuAFwATABvAGcAcwBcAEEAZwBlAG4AdABFAHgAZQBjAHUAdABvAHIALgBsAG8AZwAiAAoAIAAgACAAIAAkAGkAbgB0AHUAbgBlAEwAbwBnADIAIAA9ACAASgBvAGkAbgAtAFAAYQB0AGgAIAAkAEUAbgB2ADoAUAByAG8AZwByAGEAbQBEAGEAdABhACAALQBjAGgAaQBsAGQAcABhAHQAaAAgACIATQBpAGMAcgBvAHMAbwBmAHQAXABJAG4AdAB1AG4AZQBNAGEAbgBhAGcAZQBtAGUAbgB0AEUAeAB0AGUAbgBzAGkAbwBuAFwATABvAGcAcwBcAEkAbgB0AHUAbgBlAE0AYQBuAGEAZwBlAG0AZQBuAHQARQB4AHQAZQBuAHMAaQBvAG4ALgBsAG8AZwAiAAoAIAAgACAAIABTAGUAdAAtAEMAbwBuAHQAZQBuAHQAIAAtAEYAbwByAGMAZQAgAC0AQwBvAG4AZgBpAHIAbQA6ACQARgBhAGwAcwBlACAALQBQAGEAdABoACAAJABpAG4AdAB1AG4AZQBMAG8AZwAxACAALQBWAGEAbAB1AGUAIAAoAEcAZQB0AC0AQwBvAG4AdABlAG4AdAAgAC0AUABhAHQAaAAgACQAaQBuAHQAdQBuAGUATABvAGcAMQAgAHwAIABTAGUAbABlAGMAdAAtAFMAdAByAGkAbgBnACAALQBQAGEAdAB0AGUAcgBuACAAIgBQAGEAcwBzAHcAbwByAGQAIgAgAC0ATgBvAHQATQBhAHQAYwBoACkACgAgACAAIAAgAFMAZQB0AC0AQwBvAG4AdABlAG4AdAAgAC0ARgBvAHIAYwBlACAALQBDAG8AbgBmAGkAcgBtADoAJABGAGEAbABzAGUAIAAtAFAAYQB0AGgAIAAkAGkAbgB0AHUAbgBlAEwAbwBnADIAIAAtAFYAYQBsAHUAZQAgACgARwBlAHQALQBDAG8AbgB0AGUAbgB0ACAALQBQAGEAdABoACAAJABpAG4AdAB1AG4AZQBMAG8AZwAyACAAfAAgAFMAZQBsAGUAYwB0AC0AUwB0AHIAaQBuAGcAIAAtAFAAYQB0AHQAZQByAG4AIAAiAFAAYQBzAHMAdwBvAHIAZAAiACAALQBOAG8AdABNAGEAdABjAGgAKQAKAH0AYwBhAHQAYwBoAHsAJABOAHUAbABsAH0ACgAKACMAbwBuAGwAeQAgAHcAaQBwAGUAIAByAGUAZwBpAHMAdAByAHkAIABkAGEAdABhACAAYQBmAHQAZQByACAAZABhAHQAYQAgAGgAYQBzACAAYgBlAGUAbgAgAHMAZQBuAHQAIAB0AG8AIABNAHMAZgB0AAoAaQBmACgAKABHAGUAdAAtAEMAbwBuAHQAZQBuAHQAIAAtAFAAYQB0AGgAIAAkAGkAbgB0AHUAbgBlAEwAbwBnADIAIAB8ACAAUwBlAGwAZQBjAHQALQBTAHQAcgBpAG4AZwAgAC0AUABhAHQAdABlAHIAbgAgACIAUABvAGwAaQBjAHkAIAByAGUAcwB1AGwAdABzACAAYQByAGUAIABzAHUAYwBjAGUAcwBzAGYAdQBsAGwAeQAgAHMAZQBuAHQALgAiACkAKQB7AAoAIAAgACAAIABXAHIAaQB0AGUALQBDAHUAcwB0AG8AbQBFAHYAZQBuAHQATABvAGcAIAAiAEkAbgB0AHUAbgBlACAAbABvAGcAZgBpAGwAZQAgAGkAbgBkAGkAYwBhAHQAZQBzACAAcwBjAHIAaQBwAHQAIAByAGUAcwB1AGwAdABzACAAaABhAHYAZQAgAGIAZQBlAG4AIAByAGUAcABvAHIAdABlAGQAIAB0AG8AIABNAGkAYwByAG8AcwBvAGYAdAAiAAoAIAAgACAAIABTAGUAdAAtAEMAbwBuAHQAZQBuAHQAIAAtAEYAbwByAGMAZQAgAC0AQwBvAG4AZgBpAHIAbQA6ACQARgBhAGwAcwBlACAALQBQAGEAdABoACAAJABpAG4AdAB1AG4AZQBMAG8AZwAyACAALQBWAGEAbAB1AGUAIAAoAEcAZQB0AC0AQwBvAG4AdABlAG4AdAAgAC0AUABhAHQAaAAgACQAaQBuAHQAdQBuAGUATABvAGcAMgAgAHwAIABTAGUAbABlAGMAdAAtAFMAdAByAGkAbgBnACAALQBQAGEAdAB0AGUAcgBuACAAIgBQAG8AbABpAGMAeQAgAHIAZQBzAHUAbAB0AHMAIABhAHIAZQAgAHMAdQBjAGMAZQBzAHMAZgB1AGwAbAB5ACAAcwBlAG4AdAAuACIAIAAtAE4AbwB0AE0AYQB0AGMAaAApAAoAIAAgACAAIABTAHQAYQByAHQALQBTAGwAZQBlAHAAIAAtAHMAIAA5ADAACgAgACAAIAAgAHQAcgB5AHsACgAgACAAIAAgACAAIAAgACAAZgBvAHIAZQBhAGMAaAAoACQAVABlAG4AYQBuAHQAIABpAG4AIAAoAEcAZQB0AC0AQwBoAGkAbABkAEkAdABlAG0AIAAiAEgASwBMAE0AOgBcAFMAbwBmAHQAdwBhAHIAZQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwASQBuAHQAdQBuAGUATQBhAG4AYQBnAGUAbQBlAG4AdABFAHgAdABlAG4AcwBpAG8AbgBcAFMAaQBkAGUAQwBhAHIAUABvAGwAaQBjAGkAZQBzAFwAUwBjAHIAaQBwAHQAcwBcAFIAZQBwAG8AcgB0AHMAIgApACkAewAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGYAbwByAGUAYQBjAGgAKAAkAHMAYwByAGkAcAB0ACAAaQBuACAAKABHAGUAdAAtAEMAaABpAGwAZABJAHQAZQBtACAAJABUAGUAbgBhAG4AdAAuAFAAUwBQAGEAdABoACkAKQB7AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAkAGoAcwBvAG4AIAA9ACAAKAAoAEcAZQB0AC0ASQB0AGUAbQBQAHIAbwBwAGUAcgB0AHkAIAAtAFAAYQB0AGgAIAAoAEoAbwBpAG4ALQBQAGEAdABoACAAJABzAGMAcgBpAHAAdAAuAFAAUwBQAGEAdABoACAALQBDAGgAaQBsAGQAUABhAHQAaAAgACIAUgBlAHMAdQBsAHQAIgApACAALQBOAGEAbQBlACAAIgBSAGUAcwB1AGwAdAAiACkALgBSAGUAcwB1AGwAdAAgAHwAIABjAG8AbgB2AGUAcgB0AGYAcgBvAG0ALQBqAHMAbwBuACkACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGkAZgAoACQAagBzAG8AbgAuAFAAbwBzAHQAUgBlAG0AZQBkAGkAYQB0AGkAbwBuAEQAZQB0AGUAYwB0AFMAYwByAGkAcAB0AE8AdQB0AHAAdQB0AC4AUwB0AGEAcgB0AHMAVwBpAHQAaAAoACIATABlAGEAbgBMAEEAUABTACIAKQApAHsACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAJABqAHMAbwBuAC4AUABvAHMAdABSAGUAbQBlAGQAaQBhAHQAaQBvAG4ARABlAHQAZQBjAHQAUwBjAHIAaQBwAHQATwB1AHQAcAB1AHQAIAA9ACAAIgBSAEUARABBAEMAVABFAEQAIgAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABTAGUAdAAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5ACAALQBQAGEAdABoACAAKABKAG8AaQBuAC0AUABhAHQAaAAgACQAcwBjAHIAaQBwAHQALgBQAFMAUABhAHQAaAAgAC0AQwBoAGkAbABkAFAAYQB0AGgAIAAiAFIAZQBzAHUAbAB0ACIAKQAgAC0ATgBhAG0AZQAgACIAUgBlAHMAdQBsAHQAIgAgAC0AVgBhAGwAdQBlACAAKAAkAGoAcwBvAG4AIAB8ACAAQwBvAG4AdgBlAHIAdABUAG8ALQBKAHMAbwBuACAALQBEAGUAcAB0AGgAIAAxADAAIAAtAEMAbwBtAHAAcgBlAHMAcwApACAALQBGAG8AcgBjAGUAIAAtAEMAbwBuAGYAaQByAG0AOgAkAEYAYQBsAHMAZQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABXAHIAaQB0AGUALQBDAHUAcwB0AG8AbQBFAHYAZQBuAHQATABvAGcAIAAiAHIAZQBkAGEAYwB0AGUAZAAgAGEAbABsACAAbABvAGMAYQBsACAAZABhAHQAYQAiAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAB9AAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAfQAKACAAIAAgACAAIAAgACAAIAB9AAoAIAAgACAAIAB9AGMAYQB0AGMAaAB7ACQATgB1AGwAbAB9AAoAfQA=" #base64 UTF16-LE encoded command https://www.base64encode.org/
            $Null = Register-ScheduledTask -TaskName "leanLAPS_WL" -Trigger $triggers -User "SYSTEM" -Action $Action -Force
        }
        Write-Host "LeanLAPS current password: $pwd for $($localAdminName), last changed on $(Get-Date)"
        Exit 0
    }
}

try{
    $localAdmin = $Null
    $localAdmin = Get-LocalUser -name $localAdminName -ErrorAction Stop
    if(!$localAdmin){Throw}
}catch{
    Write-CustomEventLog "$localAdminName doesn't exist yet, creating..."
    try{
        $newPwd = Get-NewPassword $minimumPasswordLength
        $newPwdSecStr = $newPwd | ConvertTo-SecureString -AsPlainText -Force
        $pwdSet = $True
        $localAdmin = New-LocalUser -PasswordNeverExpires -AccountNeverExpires -Name $localAdminName -Password $newPwdSecStr
        Write-CustomEventLog "$localAdminName created"
    }catch{
        Write-CustomEventLog "Something went wrong while provisioning $localAdminName $($_)"
        Write-Host "Something went wrong while provisioning $localAdminName $($_)"
        Exit 0
    }
}

try{
    $administratorsGroupName = (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")).Translate([System.Security.Principal.NTAccount]).Value.Split("\")[1]
    Write-CustomEventLog "local administrators group is called $administratorsGroupName"
    $group = [ADSI]::new("WinNT://$($env:COMPUTERNAME)/$($administratorsGroupName),Group")
    $administrators = $group.Invoke('Members') | % {(New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList @([Byte[]](([ADSI]$_).properties.objectSid).Value, 0)).Value}
    
    Write-CustomEventLog "There are $($administrators.count) readable accounts in $administratorsGroupName"

    if(!$administrators -or $administrators -notcontains $localAdmin.SID.Value){
        Write-CustomEventLog "$localAdminName is not a local administrator, adding..."
        $res = Add-LocalGroupMember -Group $administratorsGroupName -Member $localAdminName -Confirm:$False -ErrorAction Stop
        Write-CustomEventLog "Added $localAdminName to the local administrators group"
    }

    #disable built in admin account if specified
    foreach($administrator in $administrators){
        if($administrator.EndsWith("-500")){
            if($disableBuiltinAdminAccount){
                if((Get-LocalUser -SID $administrator).Enabled){
                    $res = Disable-LocalUser -SID $administrator -Confirm:$False
                    Write-CustomEventLog "Disabled $($administrator) because it is a built-in account and `$disableBuiltinAdminAccount is set to `$True"
                }
            }
        }
    }

    #remove other local admins if specified, only executes if adding the new local admin succeeded
    if($removeOtherLocalAdmins){
        foreach($administrator in $administrators){
            if($administrator.EndsWith("-500")){
                Write-CustomEventLog "Not removing $($administrator) because it is a built-in account and cannot be removed"
                continue
            }
            if($administrator -ne $localAdmin.SID.Value -and $approvedAdmins -notcontains $administrator){
                Write-CustomEventLog "removeOtherLocalAdmins set to True, removing $($administrator) from Local Administrators"
                $res = Remove-LocalGroupMember -Group $administratorsGroupName -Member $administrator -Confirm:$False
                Write-CustomEventLog "Removed $administrator from Local Administrators"
            }else{
                Write-CustomEventLog "Not removing $($administrator) because of whitelisting"
            }
        }
    }else{
        Write-CustomEventLog "removeOtherLocalAdmins set to False, not removing any administrator permissions"
    }
}catch{
    Write-CustomEventLog "Something went wrong while processing the local administrators group $($_)"
    Write-Host "Something went wrong while processing the local administrators group $($_)"
    Exit 0
}

if(!$pwdSet){
    try{
        Write-CustomEventLog "Setting password for $localAdminName ..."
        $newPwd = Get-NewPassword $minimumPasswordLength
        $newPwdSecStr = ConvertTo-SecureString $newPwd -asplaintext -force
        $pwdSet = $True
        $res = $localAdmin | Set-LocalUser -Password $newPwdSecStr -Confirm:$False -AccountNeverExpires -PasswordNeverExpires $True -UserMayChangePassword $True
        Write-CustomEventLog "Password for $localAdminName set to a new value, see MDE"
    }catch{
        Write-CustomEventLog "Failed to set new password for $localAdminName"
        Write-Host "Failed to set password for $localAdminName because of $($_)"
        Exit 0
    }
}

Write-Host "LeanLAPS ran successfully for $($localAdminName)"
$res = Set-Content -Path $markerFile -Value (ConvertFrom-SecureString $newPwdSecStr) -Force -Confirm:$False
Exit 1