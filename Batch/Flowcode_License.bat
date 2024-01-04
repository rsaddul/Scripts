@echo off
cls
echo Check Flowcode License for HCUC
echo ===============================
echo.
IF EXIST "%userprofile%\AppData\Local\FlowcodeLicense.txt" GOTO LicensePresent

echo FlowCodeActivation.txt not found for %username% script will now proceed with activation
echo ================================================================

IF NOT EXIST "%userprofile%\AppData\Local\FlowcodeLicense.txt" GOTO FlowCodeActivation

:FlowCodeActivation
start C:\"Program Files (x86)\Flowcode v9\launcher\flowcodelauncher.exe"
timeout /t 5 >nul

echo Activating FlowcodeLicense
echo ==========================

set FCDIR=C:\Program Files (x86)\Flowcode V9
set KEYFILE=\\azprdfs1\ITServices\Flowcode\key.txt
set LICENCEFILE=\\azprdfs1\ITServices\Flowcode\basic.key
set FCUSERID=96076933
set FCUSERNAME=softwarehcuc
set FCPASSWORD=Ac1dIMgUd9
cd %FCDIR%
"%FCDIR%\data\tools\fc_licensing.exe" -noUI -register "%KEYFILE%" "%FCUSERID%" "%LOCALAPPDATA%\FlowcodeV9\licenses\basic.key" "%LICENCEFILE%" "%FCUSERNAME%" "%FCPASSWORD%"
echo Registered with return code %ERRORLEVEL%
taskkill /IM flowcodev9.exe
timeout /t 5 >nul
start C:\"Program Files (x86)\Flowcode v9\launcher\flowcodelauncher.exe"
echo Flowcode has now been activated
echo ==================================

echo Creating FlowcodeLicense text file
echo ==================================
@echo>"%userprofile%\AppData\Local\FlowcodeLicense.txt"

echo Completed
GOTO EndRun


:LicensePresent
echo license has been activated for %username%
GOTO EndRun

:EndRun
echo.
echo Exiting...