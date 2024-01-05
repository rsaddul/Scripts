# Password Generator Function
function Generate-Password {
    param (
        [int]$Length = 10
    )

    # Default set of characters
    $Characters = "abcdefghjkmnpqrstwxyzABCDEFGHJKMNPQRSTWXYZ23456789!@#%&*"

    # Create an array of characters
    $CharArray = $Characters.ToCharArray()

    # Generate a random password
    $Password = ''
    for ($i = 0; $i -lt $Length; $i++) {
        $Password += $CharArray[(Get-Random -Minimum 0 -Maximum $CharArray.Length)]
    }

    return $Password
}

# User Input for Password Options
$Length = Read-Host "Enter the password length"
$Count = Read-Host "Enter the number of passwords to generate"

# Generate Passwords
$Passwords = 1..$Count | ForEach-Object {
    Generate-Password -Length $Length
}

# Export Generated Passwords to CSV
$Passwords | ForEach-Object {
    [PSCustomObject]@{
        Password = $_
    }
} | Export-Csv -Path "C:\passwords.csv" -NoTypeInformation

Write-Host "Passwords exported to passwords.csv file."
