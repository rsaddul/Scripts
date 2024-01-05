@echo off

set /p username="Enter username to delete: "

"%~dp0\Delprof2.exe" /id:%username%