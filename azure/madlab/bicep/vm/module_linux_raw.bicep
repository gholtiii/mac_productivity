// This bicep template should be generic for redhat raw (payg) vm creation in azure.  Any
// specific parameters are passed in.

param subnetID string

@description('The name of your virtual machine')
param vmName string

@description('The specific SKU for the VM, will have the version of Red Hat linux')
param sku string

@description('The administrator for the machine, usually azureuser')
param adminUsername string

@description('Type of authentication to use on the virtual machine.  SSH key is recommended')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

@description('The location for the virtual machine - usually eastus2')
param location string

@description('The size of the VM')
param vmSize string

@description('Name of the VNET)')
param virtualNetworkName string

@description('Name of the network security group')
param networkSecurityGroupName string

@description('Name of the network interface')
param networkInterfaceName string

@description('The OS disk type')
param osDiskType string
param planName string
param addressPrefix string
param subnetAddressPrefix string
param linuxConfiguration object

resource nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetID
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
           name: 'SSH'
           properties : {
               protocol : 'Tcp' 
               sourcePortRange :  '*'
               destinationPortRange :  '22'
               sourceAddressPrefix :  '*'
               destinationAddressPrefix: '*'
               access:  'Allow'
               priority : 1010
               direction : 'Inbound'
               sourcePortRanges : []
               destinationPortRanges : []
               sourceAddressPrefixes : []
               destinationAddressPrefixes : []
          }
      }
    ]
  }
}

resource linux_vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: location
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'redhat'
        offer: 'RHEL'
        sku: sku
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: any(authenticationType == 'password' ? null : linuxConfiguration)
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  plan: {
    name: planName
    publisher: 'redhat'
    product: '8-gen2'
  }
}

output administratorUsername string = adminUsername
