[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$DomainAdminCredentials = Get-Credential -Message "Enter Domain Admin Credentials to rename computers"

Function Get-FileName($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "csv files (*.csv)| *.csv"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
     }

#This will look in the directory and open a pop up box for you to pick the csv's located here 
# Location c:\users\username\documents
$ComputerList = Get-FileName -initialDirectory $env:userprofile\documents
$computers = Import-CSV $ComputerList

$renamedcomputers = @() 
$unavailablecomputers = @()

Foreach ($computer in $computers){
$PingTest = Test-Connection -ComputerName $computer.CurrentName -Count 1 -quiet
If ($PingTest){
    Write-Host "Renaming $($computer.currentname) to $($computer.NewName)"
        #Rename the computers in the CSV and reboot them
        Rename-Computer -ComputerName $Computer.CurrentName -NewName $Computer.NewName -DomainCredential $DomainAdminCredentials -Confirm:$false -Force -Restart
            $renamedcomputers += $computer.CurrentName
     
    }

Else{
        Write-Warning "Failed to connect to computer $($computer.currentname)"
            $unavailablecomputers += $computer.CurrentName

    }
}

$renamedcomputers | Out-File $env:userprofile\documents\renamedcomputers.txt
$unavailablecomputers | Out-File $env:userprofile\documents\unavailablecomputers.txt
$Error | Out-File $env:userprofile\documents\renamedcomputererrors.txt