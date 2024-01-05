$filePath = "C:\Windows\Temp\Aptos_Dll.txt"

if(Test-Path -Path $filePath) {
    Write-Host "The Aptos_Dll file exists."
    exit 0
} else {
    Write-Host "The Aptos_Dll file does not exist."
    exit 1
}
