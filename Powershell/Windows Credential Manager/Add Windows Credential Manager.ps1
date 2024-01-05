Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

if (Get-Module -ListAvailable -Name CredentialManager) {
    Write-Host "CredentialManager Already Installed" -ForegroundColor Yellow -BackgroundColor Black
} 
else {
    try {
        Install-Module -Name CredentialManager -AllowClobber -Confirm:$False -Force  
    }
    catch [Exception] {
        $_.message 
        exit
    }
}

if ((Get-PackageProvider -Name NuGet).version -lt "2.8.5.208") {
    try {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Confirm:$False -Force 
    }
    catch [Exception]{
        $_.message 
        exit
    }
}
else {
    Write-Host "Version of NuGet installed = " (Get-PackageProvider -Name NuGet).version -ForegroundColor Yellow -BackgroundColor Black
}
    
$sessionCredential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "glf\", "Server Crdentials")
$mpass = [System.Net.NetworkCredential]::new("",$sessionCredential.password).Password
cmdkey.exe /add:ad.glfschools.org /user:$($sessionCredential.UserName) /pass:$($mpass)

