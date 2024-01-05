# Script Name:     Detect_Client.ps1
# Description:     Detect if the SCCM Client Exists              



$CCMpath = 'C:\Windows\ccmsetup\ccmsetup.exe'
if (Test-Path $CCMpath) {
    exit 1
}
else {
    exit 0
}
