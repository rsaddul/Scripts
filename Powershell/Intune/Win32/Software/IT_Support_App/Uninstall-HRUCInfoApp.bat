@echo off
cls
echo Uninstalling HRUC InfoApp
echo ========================
echo.
IF EXIST "C:\HRUC\Scripts\IT_Support" RD /s /q "C:\HRUC\Scripts\IT_Support"
IF EXIST "C:\HRUC\Scripts\IT_Support\HRUC-Icon.ico" del /q /f "C:\HRUC\Scripts\IT_Support\HRUC-Icon.ico"
IF EXIST "C:\HRUC\Scripts\IT_Support\HRUC-Info.ps1" del /q /f "C:\HRUC\Scripts\IT_Support\HRUC-Info.ps1"
IF EXIST "C:\HRUC\Scripts\IT_Support\Start-HRUC-Info.vbs" del /q /f "C:\HRUC\Scripts\IT_Support\Start-HRUC-Info.vbs"
IF EXIST "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\HRUC InfoApp.lnk" del /q /f "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\HRUC_InfoApp.lnk"
IF EXIST "C:\HRUC\Scripts\IT_Support" RD /s /q "C:\HRUC\Scripts\IT_Support"
echo Completed