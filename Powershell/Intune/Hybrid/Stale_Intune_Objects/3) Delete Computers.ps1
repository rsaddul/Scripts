$Computers = Get-Content -Path "C:\Users\rsaddul\OneDrive - HCUC\Documents\Computers.txt"

ForEach ($Computer in $Computers) {
        
        #Remove-ADComputer -Identity $Computer -Confirm:$false
        $ComputersToDelete = Get-ADComputer -Identity $Computer
        Remove-ADObject -Identity $ComputersToDelete -Recursive -confirm:$false
        Write-Host "Computer object '$Computer' has been deleted."
}
 