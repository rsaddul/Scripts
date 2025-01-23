# Create Enterprise Application -  https://cloudinfra.net/manage-windows-laps-using-powershell/#step-1-create-an-app-registration-in-entra-admin-center

# --------- Install and import the Ascii module if not already installed --------- #
if (-not (Get-Module -ListAvailable -Name WriteAscii)) {
    Install-Module WriteAscii -Scope AllUsers -Force
} 

Write-Host "Developed by: Rhys Saddul" -ForegroundColor Yellow
Write-Host

"Starting LAPS Audit" | Write-Ascii -ForegroundColor Green -Compress


$tenantID = "9abfd72a-18ef-4aaf-8553-b839c681ead9" 
$applicationClientID = "1bae99f5-ddcb-4b8b-a30c-f1b4a2a36c1e"

Connect-MgGraph -Environment Global -TenantId $tenantID$clientIDd -ClientId $applicationClientID -Scopes "Device.Read.All","DeviceLocalCredential.Read.All"


$allDevices = Get-MgDevice -All | Where-Object {
                                    ((($_.DisplayName -like "*EDU-HQ-*") -or ($_.DisplayName -like "*EDU-FD-*") -and ($_.AccountEnabled -eq $true)))
}


$deviceinfo = @()

foreach ($deviceName in $allDevices){

$deviceDisplayName = $deviceName.DisplayName
$device = Get-LapsAADPassword -DeviceIds $deviceDisplayName -IncludePasswords -AsPlainText

        $deviceObject = New-Object PSObject -Property @{
        "DeviceName" = $device.DeviceName
        "DeviceId" = $device.DeviceId
        "Account" = $device.Account
        "Password" = $device.Password
        "PasswordExpirationTime" = $device.PasswordExpirationTime
        "PasswordUpdateTime" = $device.PasswordUpdateTime
        }
    $deviceinfo += $deviceObject
}

$deviceinfo | Export-Csv -path "C:\Eduthing_Laps.csv" -NoTypeInformation