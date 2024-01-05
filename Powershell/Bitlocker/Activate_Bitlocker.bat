
manage-bde -protectors -get c:
for /f "skip=4 tokens=2 delims=:" %%g in ('"manage-bde -protectors -get c:"') do set MyKey=%%g
echo %MyKey%
manage-bde -protectors -adbackup c: -id%MyKey%