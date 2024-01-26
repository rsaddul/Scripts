# Install the Exchange Online PowerShell Module (if not already installed)
Install-Module -Name ExchangeOnlineManagement

# Import the ExchangeOnlineManagement module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline 

# Using HTML Formatting
Set-MailboxAutoReplyConfiguration -Identity "edutest@brightonhill.hants.sch.uk" -AutoReplyState Enabled -InternalMessage "" -ExternalMessage "<html><body><p>Thank you for contacting Brighton Hill Community School. This is an automated response to acknowledge safe receipt of your email.</p><p>Except in extenuating circumstances, we endeavor to respond to emails within 3 school working days of receipt. This is because the matter may need consideration and because colleagues spend a high proportion of their working day teaching and supporting students.</p><p>If you don't receive a reply within 3 working days, it may be that a colleague is absent or urgent matters have prevented them from replying within the usual time frame; please re-send the email to the intended recipient and to the admin@brightonhill.hants.sch.uk email address.</p><p>If your email relates to a safeguarding matter, please don’t hesitate to forward your email to safeguarding@brightonhill.hants.sch.uk and we will deal with the concern as a matter of urgent priority.</p><p>If you are contacting us to raise a safeguarding concern and it is out of school hours or term time, please contact Hampshire County Council's safeguarding team on: 0300 555 1384 or the police on 101.</p><p>If a child is in immediate danger, please contact the police using 999.</p></body></html>" -ExternalAudience All

# No HTML Formatting
Set-MailboxAutoReplyConfiguration -Identity "edutest@brightonhill.hants.sch.uk" -AutoReplyState Enabled -InternalMessage "" -ExternalMessage "Thank you for contacting Brighton Hill Community School. This is an automated response to acknowledge safe receipt of your email. Except in extenuating circumstances, we endeavor to respond to emails within 3 school working days of receipt. This is because the matter may need consideration and because colleagues spend a high proportion of their working day teaching and supporting students. If you don't receive a reply within 3 working days, it may be that a colleague is absent or urgent matters have prevented them from replying within the usual time frame; please re-send the email to the intended recipient and to the admin@brightonhill.hants.sch.uk email address. If your email relates to a safeguarding matter, please don’t hesitate to forward your email to safeguarding@brightonhill.hants.sch.uk, and we will deal with the concern as a matter of urgent priority. If you are contacting us to raise a safeguarding concern and it is out of school hours or term time, please contact Hampshire County Council's safeguarding team on: 0300 555 1384 or the police on 101. If a child is in immediate danger, please contact the police using 999." -ExternalAudience All

# Check Mailbox AutoReply Configuration
Get-MailboxAutoReplyConfiguration -Identity "edutest@brightonhill.hants.sch.uk"

