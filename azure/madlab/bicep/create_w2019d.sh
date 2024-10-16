#!/bin/sh -eux

# Tenant and Subscription and other info are available in the portal
#
# BLUELAB:
#   Tenant Name:        bluelab.bwce.io
#   Tenant ID:          40a09013-3926-4c86-902d-87c198cfb180
#   Subscription Name:  bluelab.bwce.io_sharedservices
#   Subscription ID:    4dac0de0-97a9-4ed7-906c-1d84870ad194
#   Image Gallery Name:             image.gallery.live.useast2
#   Image Gallery Subscription ID:  45849564-d2b1-428a-aea7-70c698736420
#
# MADLAB:
#   Tenant Name:        madlab.bwce.io
#   Tenant ID:          8fdf8305-0472-4380-ba18-a3265c2bb8b0  (Get this from here: https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Overview)
#   Subscription Name:  madlab.bwce.io_genpop
#   Subscription ID:    bb22f549-ff4d-405f-b765-7a2647438259
#   Image Gallery Name:             
#
# This will only work if the machine you are logging in from is an Azure VM
# az login --identity --tenant bluelab.bwce.io
az login --tenant madlab.bwce.io
az account set --subscription madlab.bwce.io_genpop

VM_SUBSCRIPTION=madlab.bwce.io_genpop
VM_SUBSCRIPTION_ID=bb22f549-ff4d-405f-b765-7a2647438259
VM_NAME="it-gh2019d-ml1"
VM_RG="rg_gholt"

VIRTUAL_NETWORK_AND_SUBNET="vnet-gholt-eastus2/default"
VIRTUAL_NETWORK=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $1}')
VIRTUAL_SUBNET=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $2}')
VIRTUAL_NETWORK_RG="rg-gholt-vnet-eastus2"

SUBNET_ID=$(az network vnet subnet show --resource-group ${VIRTUAL_NETWORK_RG} --name ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} --query id -o tsv)

# Note that public IPs are not allowed by policy, but are a required variable upon resource creation, so create an empty resource here.


#
#export subnetid=`az network vnet subnet show -g ${VIRTUAL_NETWORK_RG}  -n ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} | jq -r .id`

az deployment sub create --name ${VM_NAME} --template-file ./vm-windows.bicep --location eastus2 --parameters vmName=${VM_NAME} subnetID=${SUBNET_ID} sku=2019-Datacenter
