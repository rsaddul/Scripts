' Script to start HCUC Info cmdlet opening a PowerShell window

Set objShell = CreateObject("WScript.Shell")
objShell.run("powershell.exe -executionpolicy bypass -noexit -nologo -file C:\HCUC\SharePoint\UX\AD-UX-IT-SPSync.ps1")
