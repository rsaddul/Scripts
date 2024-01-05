@echo off
cls
echo Installing HCUC InfoApp
echo ======================
echo.
IF NOT EXIST "C:\HCUC\IT_Support" MD "C:\HCUC\IT_Support"
IF EXIST "C:\HCUC\IT_Support" attrib +s -h "C:\HCUC\IT_Support"

copy /y v2.1.txt "C:\HCUC\IT_Support"
pause
copy /y HCUC-Icon.ico "C:\HCUC\IT_Support"
pause
copy /y HCU-Info.ps1 "C:\HCUC\IT_Support"
pause
copy /y Start-HCUC-Info.vbs "C:\HCUC\IT_Support"
pause
copy /y "HCUC InfoApp.lnk" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp"
pause
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -NoLogo -ExecutionPolicy RemoteSigned -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"
pause

echo Completed
