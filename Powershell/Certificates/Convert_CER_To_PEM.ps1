# Replace this path with your actual certificate path
$certPath = "C:\Users\RhysSaddul\Downloads\MDM_ Microsoft Corporation_Certificate.cer"

# Read the certificate content
$certificate = Get-Content -Path $certPath -Raw

# Save the certificate in PEM format
$certificate | Set-Content -Path "C:\Users\RhysSaddul\Downloads\MDM_ Microsoft Corporation_Certificate.pem" -Force
