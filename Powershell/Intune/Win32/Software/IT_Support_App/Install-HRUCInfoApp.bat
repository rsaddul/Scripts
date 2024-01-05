@echo off
cls
echo Installing HRUC InfoApp
echo ======================
echo.
IF NOT EXIST "C:\HRUC\Scripts\IT_Support" MD "C:\HRUC\Scripts\IT_Support"
IF EXIST "C:\HRUC\Scripts\IT_Support" attrib +s -h "C:\HRUC\Scripts\IT_Support"

copy /y v2.1.txt "C:\HRUC\Scripts\IT_Support"
pause
copy /y HRUC-Icon.ico "C:\HRUC\Scripts\IT_Support"
pause
copy /y HCU-Info.ps1 "C:\HRUC\Scripts\IT_Support"
pause
copy /y Start-HRUC-Info.vbs "C:\HRUC\Scripts\IT_Support"
pause
copy /y "HRUC_InfoApp.lnk" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp"
pause
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -NoLogo -ExecutionPolicy RemoteSigned -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned"
pause

echo Completed
