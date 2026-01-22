# ========= Fancy Banner (unchanged) =========
$DevelopedBy = @"
 _____                                                                             _____ 
( ___ )                                                                           ( ___ )
 |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   | 
 |   |  ____    _                       ____                _       _           _  |   | 
 |   | |  _ \  | |__    _   _   ___    / ___|    __ _    __| |   __| |  _   _  | | |   | 
 |   | | |_) | | '_ \  | | | | / __|   \___ \   / _` |  / _   | /  _  | | | | | | | |   | 
 |   | |  _ <  | | | | | |_| | \__ \    ___) | | (_| | | (_| | | (_| | | |_| | | | |   | 
 |   | |_| \_\ |_| |_|  \__, | |___/   |____/   \__,_|  \__,_|  \__,_|  \__,_| |_| |   | 
 |   |                  |___/                                                      |   | 
 |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___| 
(_____)                                                                           (_____)
"@
for ($i=0;$i -lt $DevelopedBy.length;$i++){
    $c = if ($i%2) {"Red"} elseif ($i%5) {"Yellow"} elseif ($i%7) {"Green"} else {"White"}
    Write-Host $DevelopedBy[$i] -NoNewline -ForegroundColor $c
}
Write-Host ""

# ========= Settings =========
$CsvPath = "C:\Users\RhysSaddul\Downloads\Block_Sign-in.csv"  # CSV must have a header: Email
$RevokeSessions = $true   # set to $false if you only want to disable sign-in


$scopes = @("User.ReadWrite.All")
if ($RevokeSessions) { $scopes += "User.RevokeSessions.All" }

Connect-MgGraph -Scopes $scopes | Out-Null

try {
    $csv = Import-Csv -Path $CsvPath

    foreach ($row in $csv) {
        $userEmail = $row.Email.Trim()
        if ([string]::IsNullOrWhiteSpace($userEmail)) { continue }

        try {
            # Get user by UPN (works when UPN == email in Entra ID)
            $user = Get-MgUser -UserId $userEmail -ErrorAction Stop

            # If already disabled, skip; else disable
            if ($user.AccountEnabled -eq $false) {
                Write-Host "User $userEmail is already blocked from signing in." -ForegroundColor Yellow
            } else {
                Update-MgUser -UserId $user.Id -AccountEnabled:$false -ErrorAction Stop
                Write-Host "User $userEmail has been blocked from signing in." -ForegroundColor Green
            }

            if ($RevokeSessions) {
                Revoke-MgUserSignInSession -UserId $user.Id -ErrorAction Stop
                Write-Host "   -> Sessions revoked for $userEmail." -ForegroundColor DarkCyan
            }
        }
        catch {
            Write-Host "Failed for $userEmail : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
finally {
    Disconnect-MgGraph | Out-Null
}
