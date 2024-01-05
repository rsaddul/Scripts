@echo off
cls
title Resetting Start Menu to Default
regedit.exe /S "\\resource.uc\NETLOGON\Start\Start\ResetStartMenutoDefault.reg"
rd /s /q %localappdata%\Microsoft\Windows\Shell
cls
echo Resetting Start Menu Layout
echo ===========================
echo.
echo Removing Start Menu Settings...
echo Refreshing UI...
echo.
call "\\resource.uc\NETLOGON\Start\ReloadExplorer.bat"
