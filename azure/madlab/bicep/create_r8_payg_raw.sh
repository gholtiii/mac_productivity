#!/bin/sh -eux

# Tenant and Subscription and other info are available in the portal
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
# The --identity option will only work if the machine you are logging in from is an Azure VM
# az login --identity --tenant bluelab.bwce.io


az login --tenant madlab.bwce.io
az account set --subscription madlab.bwce.io_genpop

# Here's the URL for the offers
# https://portal.azure.com/#view/Microsoft_Azure_Marketplace/GalleryItemDetailsBladeNopdl/id/redhat.rhel-20190605/selectionMode~/false/resourceGroupId//resourceGroupLocation//dontDiscardJourney~/false/selectedMenuId/home/launchingContext~/%7B%22galleryItemId%22%3A%22redhat.rhel-201906059_2%22%2C%22source%22%3A%5B%22GalleryFeaturedMenuItemPart%22%2C%22VirtualizedTileDetails%22%5D%2C%22menuItemId%22%3A%22home%22%2C%22subMenuItemId%22%3A%22Search%20results%22%2C%22telemetryId%22%3A%220118972e-51ec-46dc-80be-f03acc55e50a%22%7D/searchTelemetryId/4cffa50b-4ab4-46ee-8e46-807819cc0986

PUBLISHER=RedHat
OFFER=rhel-raw
SKU=8-raw-gen2
URN="${PUBLISHER}:${OFFER}:${SKU}:latest"

# If the image has a plan, accept the legal terms for the image we will use
plan=$(az vm image show --urn "${URN}" --query plan)
if [[ "${plan}" == "" ]]; then
    echo "Image URN '${URN}' does not require accepting terms"
else
    az vm image terms accept --urn "${URN}"
fi

VM_SUBSCRIPTION=madlab.bwce.io_genpop
VM_SUBSCRIPTION_ID=bb22f549-ff4d-405f-b765-7a2647438259

# Use available resource group, vnet, and subnet resources that are set up for connectivity through the MADLAB VPN EAST Settings
VIRTUAL_NETWORK_RG="spoke01-madlab-eastus2-rg"
# spoke-01-madlab-eastus2-subnet2 is 10.242.201.0/25 - https://portal.azure.com/#@madlab.bwce.io/resource/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/spoke01-madlab-eastus2-rg/providers/Microsoft.Network/virtualNetworks/spoke01-madlab-eastus2-vnet/subnets
VIRTUAL_NETWORK_AND_SUBNET="spoke01-madlab-eastus2-vnet/spoke01-madlab-eastus2-subnet2"
VIRTUAL_NETWORK=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $1}')
VIRTUAL_SUBNET=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $2}')

VM_NAME="ghr8-payg-ml-3r"


SUBNET_ID=$(az network vnet subnet show --resource-group ${VIRTUAL_NETWORK_RG} --name ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} --query id -o tsv)

# Note that public IPs are not allowed by policy, but are a required variable upon resource creation, so create an empty resource here.


#
#export subnetid=`az network vnet subnet show -g ${VIRTUAL_NETWORK_RG}  -n ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} | jq -r .id`

az deployment sub create --name ${VM_NAME} --template-file ./vm-linux-payg.bicep --location eastus2 --parameters vmName="${VM_NAME}" subnetID=${SUBNET_ID} publisher=${PUBLISHER} offer="${OFFER}" sku="${SKU}" virtualNetworkName=${VIRTUAL_NETWORK}
