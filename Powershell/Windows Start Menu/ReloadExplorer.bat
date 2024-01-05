@echo off
cls
taskkill /im explorer.exe /f
ie4uinit.exe -show
del %localappdata%\IconCache.db /q
start explorer.exe


:End

