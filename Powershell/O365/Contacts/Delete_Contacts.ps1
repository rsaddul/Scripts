Connect-ExchangeOnline

Connect-ExchangeOnline

$CSV = "C:\Users\RhysSaddul\OneDrive - eduthing\TAS_Contacts.csv"

$Contacts = Import-Csv -Path $CSV

foreach ($Contact in $Contacts) {
    $Email = $Contact.UserPrincipalName

    # Try to find the MailContact
    $mailContact = Get-MailContact -Filter "ExternalEmailAddress -eq 'SMTP:$Email'" -ErrorAction SilentlyContinue

    if ($mailContact) {
        Remove-MailContact -Identity $mailContact.Identity -Confirm:$false
        Write-Host "Deleted $Email" -ForegroundColor Green
    } else {
        Write-Host "No MailContact found for $Email" -ForegroundColor Red
    }
}
