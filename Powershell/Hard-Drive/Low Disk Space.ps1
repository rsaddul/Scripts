# Drives to check: set to $null or empty to check all local (non-network) drives
# $drives = @("C","D");
$drives = $null;

# The minimum disk size to check for raising the warning
$minSize = 20GB;

# SMTP configuration: username, password & so on
$email_username = "rhys.saddul@gmail.com";
$email_password = "";
$email_smtp_host = "smtp.gmail.com";
$email_smtp_port = 587;
$email_smtp_SSL = 0;
$email_from_address = "rhys.saddul@gmail.com";
$email_to_address = "rhys.saddul@gmail.com";


if ($drives -eq $null -Or $drives -lt 1) {
    $localVolumes = Get-WMIObject win32_volume;
    $drives = @();
    foreach ($vol in $localVolumes) {
        if ($vol.DriveType -eq 3 -And $vol.DriveLetter -ne $null ) {
            $drives += $vol.DriveLetter[0];
        }
    }
}
foreach ($d in $drives) {
    Write-Host ("`r`n");
    Write-Host ("Checking drive " + $d + " ...");
    $disk = Get-PSDrive $d;
    if ($disk.Free -lt $minSize) {
        Write-Host ("Drive " + $d + " has less than " + $minSize `
            + " bytes free (" + $disk.free + "): sending e-mail...");
        
        $message = new-object Net.Mail.MailMessage;
        $message.From = $email_from_address;
        foreach ($to in $email_to_address) {
            $message.To.Add($to);
        }
        $message.Subject =  ("[RunningLow] WARNING: " + $env:computername + " drive " + $d);
        $message.Subject += (" has less than " + $minSize + " bytes free ");
        $message.Subject += ("(" + $disk.Free + ")");
        $message.Body =     "Dear Administrator, `r`n`r`n";
        $message.Body +=    "This is an automatic e-mail message ";
        $message.Body +=    "sent by RunningLow Powershell Script ";
        $message.Body +=    ("to inform you that " + $env:computername + " drive " + $d + " ");
        $message.Body +=    "is running low on free space. `r`n`r`n";
        $message.Body +=    "--------------------------------------------------------------";
        $message.Body +=    "`r`n";
        $message.Body +=    ("Machine HostName: " + $env:computername + " `r`n");
        $message.Body +=    "Machine IP Address(es): ";
        $ipAddresses = Get-NetIPAddress -AddressFamily IPv4;
        foreach ($ip in $ipAddresses) {
            if ($ip.IPAddress -like "127.0.0.1") {
                continue;
            }
            $message.Body += ($ip.IPAddress + " ");
        }
        $message.Body +=    "`r`n";
        $message.Body +=    ("Used space on drive " + $d + ": " + $disk.Used + " bytes. `r`n");
        $message.Body +=    ("Free space on drive " + $d + ": " + $disk.Free + " bytes. `r`n");
        $message.Body +=    "--------------------------------------------------------------";
        $message.Body +=    "`r`n`r`n";
        $message.Body +=    "This warning will fire when the free space is lower ";
        $message.Body +=    ("than " + $minSize + " bytes `r`n`r`n");
        $message.Body +=    "Sincerely, `r`n`r`n";
        $message.Body +=    "-- `r`n";
        $message.Body +=    "RunningLow`r`n";
        $smtp = new-object Net.Mail.SmtpClient($email_smtp_host, $email_smtp_port);
        $smtp.EnableSSL = $email_smtp_port;
        $smtp.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password);
        $smtp.send($message);
        $message.Dispose();
        Write-Host "... E-Mail sent!" ; 
    }
    else {
        Write-Host ("Drive " + $d + " has more than " + $minSize + " bytes free: nothing to do.");
    }
}