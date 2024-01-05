#Set Days Variable
$Date = (Get-Date).AddDays(-180)

##########################################################################################################################################################################################################################

#Filtering All Computers where users haven't logged in
$Computer = Get-ADComputer -Properties LastLogonDate -Filter {LastLogonDate -lt $Date} | Sort LastLogonDate | Select Name, LastLogonDate
$Computer | Export-Csv "C:\log\ComputersWhereUsersHaventLoggedIn.csv" -NoTypeInformation

#Removing All Computers from AD where users haven't logged in
$Computer | ForEach {
    $Name = $_.Name
    Remove-ADComputer $_.Name -confirm:$False -WhatIf
    Write-Host "Removing $Name" -ForegroundColor Black -BackgroundColor Cyan
}


##########################################################################################################################################################################################################################

#Filtering All enabled users who haven't logged in
$Enabled = Get-ADUser -Filter {((Enabled -eq $true) -and (LastLogonDate -lt $date))} -Properties LastLogonDate | select samaccountname, LastLogonDate | Sort-Object LastLogonDate 
$Enabled | Export-Csv "C:\log\EnabledUsersWhoHaventLoggedIn.csv" -NoTypeInformation

#Removing All Users from AD who haven't logged in
$Enabled | ForEach {
    $User = $_.SamAccountName
    Remove-ADUser $_.SamAccountName -confirm:$False -WhatIf
    Write-Host "Removing $User" -ForegroundColor Black -BackgroundColor Red
}

#Disable All Users from AD who haven't logged in
$Enabled | ForEach {
    $User = $_.SamAccountName
    Disable-ADAccount $_.SamAccountName -confirm:$False -WhatIf
    Write-Host "Disabling $User" -ForegroundColor Black -BackgroundColor Red
}

##########################################################################################################################################################################################################################

#Filtering All Created a year ago but not logged in
$Created = Get-ADUser -Filter {((Enabled -eq $true) -and (whenCreated -lt $date) -and (LastLogonDate -notlike "*"))} -Properties whenCreated, LastLogonDate | select samaccountname, whenCreated | Sort-Object whenCreated
$Created | Export-Csv "C:\log\UsersCreated1YearAgoButNotLoggedIn.csv" -NoTypeInformation

#Removing All Users from AD who were created a year ago but haven't logged in
$Created | ForEach {
    $User = $_.SamAccountName
    Remove-ADUser $_.SamAccountName -confirm:$False -WhatIf
    Write-Host "Removing $User" -ForegroundColor Black -BackgroundColor Red
}

#Disable All Users from AD who were created a year ago but haven't logged in
$Created | ForEach {
    $User = $_.SamAccountName
    Disable-ADAccount $_.SamAccountName -confirm:$False -WhatIf
    Write-Host "Disabling $User" -ForegroundColor Black -BackgroundColor Red
    "Disabling $User" | Out-File "C:\logs\Created_But_Not_Logged_In_6_Montsh.txt"
}
