Get-FileHash "File location + file" | select-object Hash

########
Example:
Get-FileHash "C:\Users\Joost\Downloads\7z2201-x64.exe" | select-object Hash

Hash
----
B055FEE85472921575071464A97A79540E489C1C3A14B9BDFBDBAB60E17F36E4