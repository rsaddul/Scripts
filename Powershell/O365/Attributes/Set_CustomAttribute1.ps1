Connect-ExchangeOnline

$csvPath = "C:\Users\RhysSaddul\Downloads\Set_CustomAttribute1.csv"

Function Load-CSV {
    if (Test-Path $csvPath) {
        return Import-Csv -Path $csvPath
    } else {
        Write-Output "$csvPath does not exist"
        return $null
    }
}


# Load CSV
$users = Load-CSV

Function Set-CustomAttribute1 {
    if ($users) {
        foreach ($user in $users) {
            $upn = $user.UserPrincipalName 
            $value = $user.Code 

            # Check if mailbox exists
            $mailbox = Get-Mailbox -Identity $upn -ErrorAction SilentlyContinue

            if ($mailbox) {
                if ($value -eq "NONE") {
                    Write-Output "Clearing CustomAttribute1 for $upn..."
                    Set-Mailbox -Identity $upn -CustomAttribute1 $null
                } else {
                    Write-Output "Setting CustomAttribute1 for $upn to '$value'..."
                    Set-Mailbox -Identity $upn -CustomAttribute1 $value
                }
            } else {
                Write-Warning "User $upn not found in Exchange Online."
            }
        }
    }
}

Set-CustomAttribute1