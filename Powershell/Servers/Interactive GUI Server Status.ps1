Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$groups = @("HH Security - Servers", "HW Security - Servers", "UX Security - Servers", "HY Security - Servers", "Azure Security - Servers")  # List of security groups to check

function Check-ServerStatus {
    Param($computer)

    $status = "Online"
    if (!(Test-Connection -ComputerName $computer -Count 1 -Quiet)) {
        $status = "Offline"
        [console]::Beep(1000, 500)  # Play beep sound for 500ms
    }
    New-Object -TypeName PSObject -Property @{
        ComputerName = $computer
        Status = $status
    }
}

function Show-OfflineServersForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Offline Servers"
    $form.Size = New-Object System.Drawing.Size(400, 300)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "The following servers are offline:"
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.Size = New-Object System.Drawing.Size(360, 20)
    $form.Controls.Add($label)

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Multiline = $true
    $textbox.Location = New-Object System.Drawing.Point(20, 50)
    $textbox.Size = New-Object System.Drawing.Size(360, 200)
    $form.Controls.Add($textbox)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $okButton.Location = New-Object System.Drawing.Point(300, 260)
    $form.Controls.Add($okButton)

    $offlineServers = $args[0]
    $textbox.Text = $offlineServers -join "`r`n"

    $form.AcceptButton = $okButton
    $form.ShowDialog()
}

while ($true) {  # Run the check every 2 minutes
    $offline = @()

    foreach ($group in $groups) {
        $members = Get-ADGroupMember $group -Recursive | Where-Object { $_.objectClass -eq "computer" } | Select-Object -ExpandProperty Name
        $status = $members | ForEach-Object { Check-ServerStatus $_ }
        $offline += $status | Where-Object { $_.Status -eq "Offline" } | Select-Object -ExpandProperty ComputerName
    }

    if ($offline.Count -gt 0) {
        $offlineServers = $offline -join "`r`n"
        Show-OfflineServersForm $offlineServers
    } else {
        [System.Windows.Forms.MessageBox]::Show("All servers are online.", "Server Status", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    
    Start-Sleep -Seconds 120  # Wait for 2 minutes before running the check again
}
