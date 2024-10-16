param location string = 'East US'
param adminUsername string
param adminPassword securestring

# MADLAB ONLY SUPPORTS THE FOLLOWING 5 CIDRS for VPN ACCESS
resource myVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'myVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.242.190.0/24',
	'10.242.200.0/22',
	'10.242.206.0/24',
	'10.242.204.0/23',
	'10.242.222.0/24'
      ]
    }
  }
}

resource mySubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: myVirtualNetwork
  name: 'mySubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

resource myPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'myPublicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource myNetworkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'myNetworkInterface'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: mySubnet.id
          }
          publicIPAddress: {
            id: myPublicIP.id
          }
        }
      }
    ]
  }
}

resource myVM 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'myVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'RedHat',
        offer: 'RHEL',
        sku: '8.3',
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'myVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: myNetworkInterface.id
        }
      ]
    }
  }
}

output adminUsername string = adminUsername
output adminPassword securestring = adminPassword
