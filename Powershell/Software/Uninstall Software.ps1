$app = Get-WmiObject -Class Win32_Product | Where-Object { 
    $_.Name -like "*Smart*" 
}

$app.Uninstall()

