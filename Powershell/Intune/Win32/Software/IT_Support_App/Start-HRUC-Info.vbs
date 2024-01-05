' Script to start HRUC Info cmdlet without opening a PowerShell window

command = "powershell.exe -nologo -command C:\HRUC\Scripts\IT_Support\HRUC-Info.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0