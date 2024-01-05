# Check if any value is not set
if ((Get-WinSystemLocale | Select-Object -ExpandProperty Name) -ne "en-GB" -or
    (Get-Culture).Name -ne "en-GB" -or
    (Get-WinHomeLocation | Select-Object -ExpandProperty GeoId) -ne 242 -or
    (-not (Get-WinUserLanguageList | Where-Object {$_.LanguageTag -eq "en-GB"}))) {
    Write-Warning "Not Compliant"
    $exitCode = 1
} else {
    Write-Output "Compliant"
    $exitCode = 0
}
