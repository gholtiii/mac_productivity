These are the instructions to create test VMs in madlab.  The following are static:
SSH PUBLIC KEY: 	      	     My id_madlab2.pub key
VM_SUBSCRIPTION			     madlab.bwce.io_genpop
VM_SUBSCRIPTION_ID		     bb22f549-ff4d-405f-b765-7a2647438259

# Use available resource group, vnet, and subnet resources that are set up for connectivity through the MADLAB VPN EAST Settings                                                                             
VIRTUAL_NETWORK_RG	 	     spoke01-madlab-eastus2-rg
# spoke-01-madlab-eastus2-subnet2 is 10.242.201.0/25 - https://portal.azure.com/#@madlab.bwce.io/resource/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/spoke01-madlab-eastus2-rg/providers/Microsoft.Network/virtualNetworks/spoke01-madlab-eastus2-vnet/subnets                                                                                                                                    
VIRTUAL_NETWORK_AND_SUBNET	     spoke01-madlab-eastus2-vnet/spoke01-madlab-eastus2-subnet2

These are the variables:
vm_name:
license_model: PAYG, BYOS
