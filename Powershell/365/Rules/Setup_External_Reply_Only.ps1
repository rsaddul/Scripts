# Connect to Exchange Online
Connect-ExchangeOnline 

# Get the current date for the log file name
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$errorLogFileName = "AutoReplyErrorLog_$timestamp.txt"
$errorLogFilePath = "C:\$errorLogFileName"

# Initialize an array to store error messages
$errorMessages = @()

# Get a list of all user mailboxes
$mailboxes = Get-Mailbox -ResultSize Unlimited

# Loop through each mailbox and set the auto-reply configuration with an empty internal message
foreach ($mailbox in $mailboxes) {
    $mailboxIdentity = $mailbox.Identity
    try {
        Set-MailboxAutoReplyConfiguration -Identity $mailboxIdentity -AutoReplyState Enabled -ExternalMessage "I'm out of the office, please contact XYZ" -InternalMessage ""
    }
    catch {
        $errorMessage = "Error modifying mailbox $mailboxIdentity: $($_.Exception.Message)"
        Write-Host $errorMessage

        # Record the error message in the error log
        $errorMessages += $errorMessage
    }
}

# Disconnect from Exchange Online when you're done
Disconnect-ExchangeOnline -Confirm:$false

# Write the error log file
$errorMessages | Out-File -FilePath $errorLogFilePath

# Display a message with the error log file location
Write-Host "Error log has been saved to $errorLogFilePath."
