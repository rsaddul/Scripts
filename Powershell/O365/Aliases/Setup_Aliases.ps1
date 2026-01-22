Connect-ExchangeOnline
Connect-MgGraph -Scopes "User.ReadWrite.All"

$CsvPath = "C:\Users\RhysSaddul\OneDrive - eduthing\Documents\Migrations\365\Scripts\Aliasses\BCPS_Setup_Aliases.csv"
$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    try {
        $identity   = $user.CurrentEmail
        $newPrimary = $user.PrimarySMTP

        if (-not $identity -or -not $newPrimary) {
            Write-Warning "Row missing CurrentEmail or PrimarySMTP. Skipping."
            continue
        }

        # 1) Gather existing aliases (excluding current primary)
        $mbx = Get-Mailbox -Identity $identity -ErrorAction Stop
        $existing = @()
        foreach ($addr in $mbx.EmailAddresses) {
            $s = $addr.ToString()
            if ($s -notmatch '^SMTP:') { $existing += $s.ToLower() }
        }

        # 2) Add CSV alias columns (Alias1, Alias2, ...)
        $csvAliases = @()
        foreach ($p in $user.PSObject.Properties.Name) {
            if ($p -match '^Alias\d+$') {
                $val = $user.$p
                if ($val -and $val.Trim() -ne '') { $csvAliases += ('smtp:' + $val.Trim().ToLower()) }
            }
        }

        # 3) Keep the old sign-in email as alias (optional)
        $keepOldAsAlias = $true
        $oldAsAlias = @()
        if ($keepOldAsAlias) {
            $oldAsAlias += "smtp:$($identity.ToLower())"
        }

        # 4) Build new proxy address list
        $newList = @("SMTP:$newPrimary") + $existing + $csvAliases + $oldAsAlias
        $seen = @{}
        $newList = $newList | Where-Object { -not $seen.ContainsKey($_) -and ($seen[$_] = $true) }

        # 5) Apply to mailbox
        Set-Mailbox -Identity $identity -EmailAddresses $newList -WindowsEmailAddress $newPrimary

        # 6) Change the username/UPN
        Update-MgUser -UserId $identity -UserPrincipalName $newPrimary

        Write-Host "✅ Updated $identity -> Primary=$newPrimary; Aliases: $((($newList | Where-Object {$_ -match '^smtp:'}) -join ', '))" -ForegroundColor Green
    }
    catch {
        Write-Warning "❌ Failed for $($user.CurrentEmail): $($_.Exception.Message)"
    }
}
