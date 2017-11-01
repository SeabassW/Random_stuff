#Create Resource Group
$resourceGroupName = "VM"
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location "westeurope" 

# Select Vritual Network
$virtualNetworkName = "MyVirtualNetwork"
$locationName = "westeurope"

$susbnet = New-AzureRmVirtualNetworkSubnetConfig -Name FrontEnd -AddressPrefix 10.0.1.0/24 

$virtualNetwork = New-AzureRmVirtualNetwork -Name $virtualNetworkName `
                                            -Subnet $susbnet `
                                            -Location $locationName `
                                            -ResourceGroupName $resourceGroupName `
                                            -AddressPrefix 10.0.0.0/16                                       

                                            
# Create IP-Adres
$publicIp = New-AzureRmPublicIpAddress -Name "MyPublicIpAddress" `
                                       -ResourceGroupName $resourceGroupName `
                                       -Location $locationName -AllocationMethod Dynamic

# Create Network Interface
$networkInterface = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName `
                                                -Name "MyNetworkInterface"  `
                                                -Location $locationName `
                                                -SubnetId $virtualNetwork.Subnets[0].Id `
                                                -PublicIpAddressId $publicIp.Id `
                                                

# VM Config
$vhdUri = "https://mytargetstorageaccount.blob.core.windows.net/migratedvhds/myvhd.vhd"
$vmConfig = New-AzureRmVMConfig -VMName "MyVirtualMachine" -VMSize "Standard_A1"
$vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -Name "MyVMDisk" -VhdUri $vhdUri `
                                -CreateOption Attach -Windows
$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $networkInterface.Id

#Create VM
$vm = New-AzureRmVM -VM $vmConfig -Location $locationName -ResourceGroupName $resourceGroupName