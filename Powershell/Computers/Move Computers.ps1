$ComputersPath = Import-Csv -Path "C:\Users\rsaddul\OneDrive - HCUC\Desktop\NotInIntune.csv" -Header "ComputerName"
$TargetOU = "OU=Unsure,OU=Intune Devices,OU=HCUC,DC=resource,DC=uc"
$errors = @()

foreach ($item in $ComputersPath) {
    $computer = Get-ADComputer $item.ComputerName -ErrorAction SilentlyContinue
    if ($computer) {
        Move-ADObject -Identity $computer.DistinguishedName -TargetPath $TargetOU -Confirm:$false
        Write-Host "Computer account $($computer.Name) has been moved successfully"
    } else {
        $error = "Cannot find computer object: $($item.ComputerName)"
        $errors += $error
        Write-Host $error -ForegroundColor Red
    }
}

if ($errors.Count -gt 0) {
    $errors | Out-File -FilePath "c:\Move-ComputerErrors.log"
}
