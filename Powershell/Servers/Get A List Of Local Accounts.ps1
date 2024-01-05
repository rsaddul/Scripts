
$Log = "C:\Servers.csv"

foreach ($device in Get-Content "C:\Test.csv"){
   $Export = Invoke-Command -ComputerName $device -ScriptBlock{
        Get-LocalUser | Where-Object {$_.Enabled -eq $True} | select @{N="Computer"; E={$env:COMPUTERNAME}}, Name, Enabled, PasswordChangeableDate, PasswordExpires, UserMayChangePassword, PasswordRequired, PasswordLastSet, LastLogon
    }  
    $Export | Export-Csv -NoTypeInformation $Log -Append
} 

