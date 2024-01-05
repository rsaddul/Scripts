$userName = "IntuneAdmin"
$userExist = (Get-LocalUser).Name -Contains $userName

if ($userExist -eq $false) {
    try {
        $password = "hinyFly91?"
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        New-LocalUser -Name $userName -Description "IntuneAdmin1 local user account" -Password $securePassword -PasswordNeverExpires

        # Add the user to the local Administrators group
        Add-LocalGroupMember -Group "Administrators" -Member $userName

        Write-Host "User '$userName' created and added to the Administrators group successfully."
        Exit 0
    }
    catch {
        Write-Error $_
        Exit 1
    }
}
else {
    Write-Host "User '$userName' already exists."
    Exit 0
}
