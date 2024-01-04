@echo off
cls
echo Installing FSLogix App for HRUC
echo ===============================
echo.
IF %PROCESSOR_ARCHITECTURE% == x86 GOTO END

IF NOT EXIST "C:\Program Files\FSLogix\Apps\frxshell.exe" "\\ad.glfschools.org\library\Software\Microsoft\FSLogix\FSLogixAppsSetup.exe" /install /quiet /norestart

:END
echo Completed