# Create Separate Address Lists
# You need to create separate address lists for each group of users.
New-AddressList -Name "EDU-AL" -RecipientFilter {(RecipientTypeDetails -eq 'UserMailbox') -and (MemberOfGroup -eq "CN=EDU-Staff,OU=Groups,DC=domain,DC=com")}

# Create Global Address Lists (GALs)
# Next, create separate Global Address Lists for each group.
New-GlobalAddressList -Name "EDU-GAL" -RecipientFilter {(RecipientTypeDetails -eq 'UserMailbox') -and (MemberOfGroup -eq "CN=EDU-Staff,OU=Groups,DC=domain,DC=com")}

# Create Address Book Policies (ABPs)
# Create Address Book Policies that will link the address lists and GALs for each department.
New-AddressBookPolicy -Name "EDU-ABP" -GlobalAddressList "EDU-GAL" -AddressLists "EDU-AL"

# Apply the Address Book Policy to users in the group
Get-Mailbox -Filter {(MemberOfGroup -eq "CN=EDU-Staff,OU=Groups,DC=domain,DC=com")} | Set-Mailbox -AddressBookPolicy "EDU-ABP"
