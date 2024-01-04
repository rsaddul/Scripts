set "target=Solus"

REM Use WMIC to uninstall the software
wmic product where "name like '%%%target%%%'" call uninstall /nointeractive


