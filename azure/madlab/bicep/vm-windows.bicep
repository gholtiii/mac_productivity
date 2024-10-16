@minLength(3)
@maxLength(15)
param vmName string
param sku string

param location string = 'eastus2'
param subnetID string

targetScope = 'subscription'

resource vmrg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${vmName}-rg'
  location: location
}

module winvm './vm/module_windows.bicep' =  {
 name: vmName
 scope:  vmrg
 params: {
   subnetID: subnetID
   vmName: vmName
   sku: sku
 }
}
