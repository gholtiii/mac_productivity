@minLength(3)
@maxLength(15)

@description('The name of your virtual machine')
param vmName string

@description('The particular SKU to use')
param sku string

@description('The administrator username for the virtual machine')
param adminUsername string = 'azureuser'

@description('Type of authentication to use on the virtual machine.  SSH key is recommended')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'sshPublicKey'

@description('SSH key or password for the virtual machine.  SSH key is recommended.')
@secure()
param adminPasswordOrKey string = 'AAAAB3NzaC1yc2EAAAADAQABAAABgQC/bT3nbQXTTcvY1D8o4qq0qTCL5ML4AOPSlW85Xv3mHKo8JR/VYJMjAjwn/KqlaS4+0EM1w04I+Bstfzd0Viefpka6FfhwipC5slLlBZQBvibaC1sfAtcsqvk1WZIfa7XdrtzdkKL298pxpeMVaOq0Bxt3kmzg5yTqxuvuH7wMY55JiKtsOzXVeW931cBDHJmLp2b6nktrV5n0WIAXbhfNh33EsNH1kTquils+jtuqIQuGW3lyMjNp5371B7Bk2ONz5jGpsW4OWEv2NeRFMtwT7yQuoL++xmXofE9xPS9dZcs5wQWCOdjX2bqH8eHorUGH31VwlAQ4vA+qNP4tsgtAdmjW/97Gegb5LePsQW1dGua31zAfdaHEr5K1t2U2MdysByMTnxAjMnC4CzUhlfwb6CjRlz8TlPQM/fFaJuD7hIuvbEk3Fz1kZzmfNodEChStgDUT6FM6rGr42iobhHsPxPS/Ukyn+JUlEaaqo82AMN2E6svCVQsJxgcGadB7o3c='

// description('Unique DNS name for the public IP used to access to virtual machine (if applicable)')
// param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id)}')

@description('Location for all resources.')
param location string = 'eastus2'

@description('The size of the VM.')
param vmSize string = 'Standard_D8ds_v4'

@description('Name of the VNET.')
param virtualNetworkName string = 'vnet-gholt-eastus2'

@description('Name of the subnet in the virtual network.')
param subnetName string = 'default'

@description('Name of the Network Security Group.')
param networkSecurityGroupName string = 'nsg-gholt'

var planName = '8-gen2'
var networkInterfaceName = '${vmName}Nic'
var osDiskType = 'Standard_LRS'
var subnetAddressPrefix = '10.5.0.0/24'
var addressPrefix = '10.5.0.0/16'
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

param subnetID string

targetScope = 'subscription'

resource vmrg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${vmName}-rg'
  location: location
}

module linuxvm './vm/module_linux_raw.bicep' =  {
 name: vmName
 scope:  vmrg
 params: {
   vmName: vmName
   sku: sku
   addressPrefix: addressPrefix
   subnetAddressPrefix: subnetAddressPrefix
   location: location
   adminUsername: adminUsername
   adminPasswordOrKey: adminPasswordOrKey
   networkSecurityGroupName: networkSecurityGroupName
   virtualNetworkName: virtualNetworkName
   vmSize: vmSize
   osDiskType: osDiskType
   planName: planName
   authenticationType: authenticationType
   subnetID: subnetID
   linuxConfiguration: linuxConfiguration
   networkInterfaceName: networkInterfaceName
 }
}
