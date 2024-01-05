@if "%_ECHO%" == "" echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

@rem Constants.
set prog=%0
echo %prog%

:parse
if /i '%1' == 'device' goto :devicePolicy
if /i '%1' == 'user' goto :userPolicy

goto :usage

:usage
echo.
echo "USAGE: %prog% <device|user> <install | uninstall>"
echo.
goto :end

:devicePolicy
set devicePolicyPath=%ProgramFiles%
if exist %ProgramFiles(x86)% (
    set devicePolicyPath=%ProgramFiles(x86)%
)

if /i '%2' == 'install' (
    if not exist "%devicePolicyPath%\UniversalPrintPrinterProvisioning" mkdir "%devicePolicyPath%\UniversalPrintPrinterProvisioning"
    if not exist "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration" mkdir "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration"
    if exist printers.csv (
        copy /Y printers.csv "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration\printers.csv"
    )
    if exist uninstallprinters.csv (
        copy /Y uninstallprinters.csv "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration\uninstallprinters.csv"
    )
    goto :end
)

if /i '%2' == 'uninstall' (
    if exist "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration\printers.csv" (
        del "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration\printers.csv"
    )
    if exist "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration\uninstallprinters.csv" (
        del "%devicePolicyPath%\UniversalPrintPrinterProvisioning\Configuration\uninstallprinters.csv"
    )
    goto :end
)

goto end

:userPolicy
if /i '%2' == 'install' (
    if not exist "%AppData%\UniversalPrintPrinterProvisioning" mkdir "%AppData%\UniversalPrintPrinterProvisioning"
    if not exist "%AppData%\UniversalPrintPrinterProvisioning\Configuration" mkdir "%AppData%\UniversalPrintPrinterProvisioning\Configuration"
    if exist printers.csv (
        copy /Y printers.csv "%AppData%\UniversalPrintPrinterProvisioning\Configuration\printers.csv"
    )
    if exist uninstallprinters.csv (
        copy /Y uninstallprinters.csv "%AppData%\UniversalPrintPrinterProvisioning\Configuration\uninstallprinters.csv"
    )
    goto :end
)

if /i '%2' == 'uninstall' (
    if exist "%AppData%\UniversalPrintPrinterProvisioning\Configuration\printers.csv" (
        del "%AppData%\UniversalPrintPrinterProvisioning\Configuration\printers.csv"
    )
    if exist "%AppData%\UniversalPrintPrinterProvisioning\Configuration\uninstallprinters.csv" (
        del "%AppData%\UniversalPrintPrinterProvisioning\Configuration\uninstallprinters.csv"
    )
    goto :end
)

:end
endlocal