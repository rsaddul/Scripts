# GET COMMANDS

#Shows network configuration of local device (take note of InterfaceIndex and DNSServer Details)
Get-NetIPConfiguration

#Shows network configuration of a server with objects InterfaceIndex and DNSServer Details
Get-NetIPConfiguration -ComputerName GLF-SIMS01 | Select-Object ComputerName, InterfaceIndex

# INVOKE COMMANDS

#This will get multiple servers network configuration settings
Invoke-Command -ComputerName GLF-FILE09, GLF-FILE10 -ScriptBlock {Get-NetIPConfiguration}

#This will get multiple servers with the objects InterfaceIndex and DNSServer Details)
Invoke-Command -ComputerName GLF-SIMS01, GLF-SIMS02 -ScriptBlock {Get-NetIPConfiguration | Select-Object ComputerName, InterfaceIndex}


#This will get multiple servers DNS adddresses depending on the name of their nic and also show server names
Invoke-Command -ComputerName GLF-FILE06, GLF-SIMS01 -ScriptBlock {Get-DnsClientServerAddress -InterfaceAlias "Ethernet0","VM Network NIC" -AddressFamily IPv4}


# SET COMMANDS

#This will set the primary and alternative dns addresses for the server with Interfaceindex 10  
Set-DnsClientServerAddress -InterfaceIndex 10 -ServerAddresses 192.168.50.10, 192.168.50.11

#This will set the below two servers with InterfaceIndex 4 will get their dns settings set to the below
Invoke-Command -ComputerName GLF-FILE09, GLF-FILE10 -ScriptBlock {Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses 192.168.50.10, 192.168.50.11}


