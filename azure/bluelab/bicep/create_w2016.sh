#!/bin/sh -eux

# Tenant and Subscription and other info are available in the portal
#   Tenant Name:        bluelab.bwce.io
#   Tenant ID:          40a09013-3926-4c86-902d-87c198cfb180
#   Subscription Name:  bluelab.bwce.io_sharedservices
#   Subscription ID:    4dac0de0-97a9-4ed7-906c-1d84870ad194
#   Image Gallery Name:             image.gallery.live.useast2
#   Image Gallery Subscription ID:  45849564-d2b1-428a-aea7-70c698736420
#
# This will only work if the machine you are logging in from is an Azure VM
# az login --identity --tenant bluelab.bwce.io
az login --tenant bluelab.bwce.io
az account set --subscription bluelab.bwce.io_sharedservices

# Where are we getting the subscription from
IMAGE_GALLERY_NAME=image.gallery.live.eastus2
IMAGE_GALLERY_SUBSCRIPTION_ID=45849564-d2b1-428a-aea7-70c698736420
IMAGE_GALLERY_RG=$(echo ${IMAGE_GALLERY_NAME} |sed 's/\./-/g')-rg

VM_SUBSCRIPTION=bluelab.bwce.io_sharedservices
VM_SUBSCRIPTION_ID=4dac0de0-97a9-4ed7-906c-1d84870ad194
VM_NAME="it-ghaz-w2016-dv1"
VM_RG="rg_gholt_test_sharedservices"

# Get the VM image path here: https://portal.azure.com/#@bluelab.bwce.io/resource/subscriptions/45849564-d2b1-428a-aea7-70c698736420/resourceGroups/image-gallery-live-eastus2-rg/providers/Microsoft.Compute/galleries/image.gallery.live.eastus2/images/WIN2016-GEN2/properties
VM_IMG="/subscriptions/45849564-d2b1-428a-aea7-70c698736420/resourceGroups/image-gallery-live-eastus2-rg/providers/Microsoft.Compute/galleries/${IMAGE_GALLERY_NAME}/images/WIN2016-GEN2"

VIRTUAL_NETWORK_AND_SUBNET="vnet-spoke01-dev-eastus2/subnet02-spoke01-dev-eastus2"
VIRTUAL_NETWORK=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $1}')
VIRTUAL_SUBNET=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $2}')
VIRTUAL_NETWORK_RG="rg-spoke01-dev-eastus2"

SUBNET_ID=$(az network vnet subnet show --resource-group ${VIRTUAL_NETWORK_RG} --name ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} --query id -o tsv)

# Note that public IPs are not allowed by policy, but are a required variable upon resource creation, so create an empty resource here.


#
#export subnetid=`az network vnet subnet show -g ${VIRTUAL_NETWORK_RG}  -n ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} | jq -r .id`

az deployment sub create --name it-ghaz2016-dv1 --template-file ./vm.bicep --location eastus2 --parameters vmName="it-ghaz2016-dv1" subnetID=${SUBNET_ID} sku="2016-Datacenter"
