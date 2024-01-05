@echo off
cls
echo Uninstalling HCUC InfoApp
echo ========================
echo.
IF EXIST "C:\HCUC\IT_Support" RD /s /q "C:\HCUC\IT_Support"
IF EXIST "C:\HCUC\IT_Support\HCUC-Icon.ico" del /q /f "C:\HCUC\IT_Support\HCUC-Icon.ico"
IF EXIST "C:\HCUC\IT_Support\HCUC-Info.ps1" del /q /f "C:\HCUC\IT_Support\HCUC-Info.ps1"
IF EXIST "C:\HCUC\IT_Support\Start-HCUC-Info.vbs" del /q /f "C:\HCUC\IT_Support\Start-HCUC-Info.vbs"
IF EXIST "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\HCUC InfoApp.lnk" del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\HCUC InfoApp.lnk"
IF EXIST "C:\HCUC\IT_Support" RD /s /q "C:\HCUC\IT_Support"
echo Completed