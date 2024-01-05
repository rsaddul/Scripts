' Script to start Activate Bitlock cmdlet without opening a PowerShell window

command = "powershell.exe -Executionpolicy Bypass -nologo -noninteractive -file C:\HCUC\Scripts\Bitlocker\Activate_Bitlocker.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0