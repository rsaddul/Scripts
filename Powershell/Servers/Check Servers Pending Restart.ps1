$Computers = Get-ADComputer -Filter * -SearchBase "OU=Servers,DC=ad,DC=glfschools,DC=org" 

$Computers | Foreach { 
                        $Name = $_.Name
                        Write-Host "Starting to check $Name" -ForegroundColor Green
                        $error.clear()
                        $Connection = Test-Connection $_.Name -Count 1 -ErrorAction SilentlyContinue
                         
                    If ($error.count -eq 0){
                        Write-Host "Checking REG Key for $Name" -ForegroundColor Cyan
                        $result = Invoke-Command -ComputerName $_.Name -ScriptBlock {Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'}
                    
                    If ($result -eq $true){
                        Write-Host "$Name needs to be restarted" -ForegroundColor Black -BackgroundColor Yellow
                        $Output = "$Name needs to be restarted" | Out-File "C:\New folder\Restart.txt" -Append -Encoding ascii
                     }
                     }Else {Write-Host "Connection Failed for $Name" -ForegroundColor Red} 
                       

}
