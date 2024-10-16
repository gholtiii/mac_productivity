============================================================
List images available in madlab:

George.Holt@GeorgeHolt ~ % az vm image list --output table

============================================================
Create a resource group:

George.Holt@GeorgeHolt ~ % az group create -l eastus2 -n rg-gholt
{
  "id": "/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/rg-gholt",
  "location": "eastus2",
  "managedBy": null,
  "name": "rg-gholt",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}

============================================================
Create a resource group for the virtual network:
https://learn.microsoft.com/en-us/azure/virtual-network/quick-create-cli

George.Holt@GeorgeHolt ~ % az group create -l eastus2 -n rg-gholt-vnet-eastus2
{
  "id": "/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/rg-gholt-vnet-eastus2",
  "location": "eastus2",
  "managedBy": null,
  "name": "rg-gholt-vnet-eastus2",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}

============================================================
Create a virtual network:

George.Holt@GeorgeHolt ~ % az network vnet create --name vnet-gholt-eastus2 --resource-group rg-gholt-vnet-eastus2 --subnet-name default
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [
        "10.0.0.0/16"
      ]
    },
    "bgpCommunities": null,
    "ddosProtectionPlan": null,
    "dhcpOptions": {
      "dnsServers": []
    },
    "enableDdosProtection": false,
    "enableVmProtection": null,
    "encryption": null,
    "etag": "W/\"7bae7d17-0cc5-4ae5-9db3-9e5c973e6653\"",
    "extendedLocation": null,
    "flowTimeoutInMinutes": null,
    "id": "/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/rg-gholt-vnet-eastus2/providers/Microsoft.Network/virtualNetworks/vnet-gholt-eastus2",
    "ipAllocations": null,
    "location": "eastus2",
    "name": "vnet-gholt-eastus2",
    "provisioningState": "Succeeded",
    "resourceGroup": "rg-gholt-vnet-eastus2",
    "resourceGuid": "1e5a75b4-9ae9-4d93-aaf6-4e22e257d36f",
    "subnets": [
      {
        "addressPrefix": "10.0.0.0/24",
        "addressPrefixes": null,
        "applicationGatewayIpConfigurations": null,
        "delegations": [],
        "etag": "W/\"7bae7d17-0cc5-4ae5-9db3-9e5c973e6653\"",
        "id": "/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/rg-gholt-vnet-eastus2/providers/Microsoft.Network/virtualNetworks/vnet-gholt-eastus2/subnets/default",
        "ipAllocations": null,
        "ipConfigurationProfiles": null,
        "ipConfigurations": null,
        "name": "default",
        "natGateway": null,
        "networkSecurityGroup": null,
        "privateEndpointNetworkPolicies": "Disabled",
        "privateEndpoints": null,
        "privateLinkServiceNetworkPolicies": "Enabled",
        "provisioningState": "Succeeded",
        "purpose": null,
        "resourceGroup": "rg-gholt-vnet-eastus2",
        "resourceNavigationLinks": null,
        "routeTable": null,
        "serviceAssociationLinks": null,
        "serviceEndpointPolicies": null,
        "serviceEndpoints": null,
        "type": "Microsoft.Network/virtualNetworks/subnets"
      }
    ],
    "tags": {},
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": []
  }
}

============================================================

