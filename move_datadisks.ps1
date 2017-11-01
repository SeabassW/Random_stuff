#Provide the subscription Id of the subscription where managed disk exists
$sourceSubscriptionId='f066eaf1-e8fe-4457-a69d-148a62a7c682'

#Provide the name of your resource group where managed disk exists
$sourceResourceGroupName='VM_W10'

#Provide the name of the managed disk
$managedDiskName='Seabass_OsDisk_1_c1614d82d0dc42f18a8c6ab3cdb4faca'

#Set the context to the subscription Id where Managed Disk exists
Select-AzureRmSubscription -SubscriptionId $sourceSubscriptionId

#Get the source managed disk
$managedDisk= Get-AzureRMDisk -ResourceGroupName $sourceResourceGroupName -DiskName $managedDiskName

#Provide the subscription Id of the subscription where managed disk will be copied to
#If managed disk is copied to the same subscription then you can skip this step
$targetSubscriptionId='332990a9-6bb3-4e2d-9875-a996fe03c894'

#Name of the resource group where snapshot will be copied to
$targetResourceGroupName='VM_W10'

#Set the context to the subscription Id where managed disk will be copied to
#If snapshot is copied to the same subscription then you can skip this step
Select-AzureRmSubscription -SubscriptionId $targetSubscriptionId

$diskConfig = New-AzureRmDiskConfig -SourceResourceId $managedDisk.Id -Location $managedDisk.Location -CreateOption Copy 

#Create a new managed disk in the target subscription and resource group
New-AzureRmDisk -Disk $diskConfig -DiskName $managedDiskName -ResourceGroupName $targetResourceGroupName