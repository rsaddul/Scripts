@echo off
cls
echo Checking Flowcode Folder Exists
echo ===============================
echo.
IF EXIST "C:\Program Files (x86)\Flowcode v9\launcher\" GOTO CheckFlowCodeFile

echo Flowcode v9 not found. Please install Flowcode v9 and try again.
GOTO EndRun

:CheckFlowCodeFile
cls
echo Checking Flowcode License File
echo ==============================
echo.
IF EXIST "%userprofile%\AppData\Local\FlowcodeLicense.txt" GOTO LicensePresent

echo FlowCode license file not found for %username% script will now proceed with activation
echo ======================================================================================

IF NOT EXIST "%userprofile%\AppData\Local\FlowcodeLicense.txt" GOTO FlowCodeActivation

:FlowCodeActivation
start C:\"Program Files (x86)\Flowcode v9\launcher\flowcodelauncher.exe"
timeout /t 5 >nul

echo Activating FlowcodeLicense
echo ==========================

set FCDIR=C:\Program Files (x86)\Flowcode V9
set KEYFILE=%~dp0key.txt
set LICENCEFILE=%~dp0basic.key
set FCUSERID=21696122
set FCUSERNAME=RuTC_ITSupport
set FCPASSWORD=matrix12738913
cd %FCDIR%
"%FCDIR%\data\tools\fc_licensing.exe" -noUI -register "%KEYFILE%" "%FCUSERID%" "%LOCALAPPDATA%\FlowcodeV9\licenses\basic.key" "%LICENCEFILE%" "%FCUSERNAME%" "%FCPASSWORD%"
echo Registered with return code %ERRORLEVEL%
taskkill /F /IM flowcodev9.exe
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
