$list = $null
$list = @()
$vnets = Get-AzVirtualNetwork

foreach ($vnet in $vnets) {
   $subnets = $vnet.Subnets.name
    foreach ($subnet in $subnets){ 
    $SubnetDetails = Get-AzVirtualNetworkSubnetConfig -Name $subnet -VirtualNetwork $vnet
    
        $list += [PSCustomObject]@{
            VNETName = $vnet.Name
            VNETAddressSpaces = $vnet.AddressSpace.AddressPrefixes -join ', '
            SubnetName = $SubnetDetails.name
            SubnetsPrefix = $SubnetDetails.AddressPrefix -join ''
            SubnetNSG = if($SubnetDetails.NetworkSecurityGroup -eq $Null) {"No NSG"} else{$SubnetDetails.NetworkSecurityGroup.id.split('/')[8]}
            SubnetNSGID = if($SubnetDetails.NetworkSecurityGroup -eq $Null) {"No NSG"} else{$SubnetDetails.NetworkSecurityGroup.id}
                                   }
                                 }

                          }


$list | Export-Csv -Path "C:\Test.csv"