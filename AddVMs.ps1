Enable-WindowsOptionalFeature –Online –FeatureName Microsoft-Hyper-V 

$SRV1 = "CLient-S01" # Name of VM running Server Operating System
$SRAM = 1GB		 # RAM assigned to Server Operating System
$SRV1VHD = 40GB	 # Size of Hard-Drive for Server Operating System
$VMLOC = "D:\HyperV"	 # Location of the VM and VHDX files
$NetworkSwitch1 = "PrivateSwitch1"	# Name of the Network Switch
$WSISO = "D:\isos\W2K8R2.iso"	     # Windows Server 2008 ISO

$HOST_IP = "192.168.3.10" #Host IP Address
$HOST_Netmask = "255.255.255.0"  
$HOST_Gateway = "192.168.3.1"

$VM_IP = "192.168.3.15" #VM IP Address
$VM_Netmask = "255.255.255.0"  
$VM_Gateway = "192.168.3.1" 

$DNS_1 = "192.168.3.15"
$DNS_2 = "8.8.8.8"

# Create VM Folder 
MD $VMLOC -ErrorAction SilentlyContinue
#Network Switch
$TestSwitch = Get-VMSwitch -Name $NetworkSwitch1 -ErrorAction SilentlyContinue; if ($TestSwitch.Count -EQ 0){New-VMSwitch -Name $NetworkSwitch1 -SwitchType Private}


#Create VM
New-VM -Name $SRV1 -Path $VMLOC -MemoryStartupBytes $SRAM -NewVHDPath $VMLOC\$SRV1.vhdx -NewVHDSizeBytes $SRV1VHD -SwitchName $NetworkSwitch1
#Set CD Drive
Set-VMDvdDrive -VMName $SRV1 -Path $WSISO


#Set Host Network Info

New-NetIPAddress –InterfaceAlias "Ethernet" –IPAddress $HOST_IP –PrefixLength 24 -DefaultGateway $HOST_Gateway
#Set DNS info
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $DNS_1, $DNS_2

#Set VM Network Info
New-NetIPAddress –InterfaceAlias "Wired Ethernet Connection" –IPAddress $HOST_IP –PrefixLength 24 -DefaultGateway $HOST_Gateway
#Set DNS info
Set-DnsClientServerAddress -InterfaceAlias "Wired Ethernet Connection" -ServerAddresses $DNS_1, $DNS_2

