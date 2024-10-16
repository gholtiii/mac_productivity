@minLength(3)
@maxLength(15)
param vmName string
param sku string

param location string = 'eastus2'
param subnetID string
param linux bool = false

targetScope = 'subscription'

resource vmrg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${vmName}-rg'
  location: location
}
module winvm './vm/module.bicep' =  {
 name: vmName
 scope:  vmrg
 params: {
   subnetID: subnetID
   vmName: vmName
   linux: linux
   sku: sku
 }
}
