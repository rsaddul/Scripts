# Check if values are compliant
if ((Get-WinSystemLocale).Name -eq "en-GB" -and
    (Get-Culture).Name -eq "en-GB" -and
    (Get-WinHomeLocation).GeoId -eq 242 -and
    (Get-WinUserLanguageList | Where-Object {$_.LanguageTag -eq "en-GB"})) {
    Write-Output "Compliant"
    Exit 0
}

Write-Warning "Not Compliant. Attempting remediation..."

# Set values
Set-WinSystemLocale -SystemLocale "en-GB" -PassThru | Out-Null
Set-Culture -CultureInfo "en-GB" | Out-Null
Set-WinHomeLocation -GeoId 242 -PassThru | Out-Null

$NewLanguageList = New-WinUserLanguageList -LanguageTag "en-GB"
Set-WinUserLanguageList -LanguageList $NewLanguageList -Force | Out-Null

# Verify remediation
$complianceCheck = (
    (Get-WinSystemLocale).Name -eq "en-GB" -and
    (Get-Culture).Name -eq "en-GB" -and
    (Get-WinHomeLocation).GeoId -eq 242 -and
    (Get-WinUserLanguageList | Where-Object {$_.LanguageTag -eq "en-GB"})
)

if ($complianceCheck) {
    Write-Output "Remediation successful. System is now compliant."
    Exit 0
} else {
    Write-Warning "Remediation failed. System is still non-compliant."
    Exit 1
}
