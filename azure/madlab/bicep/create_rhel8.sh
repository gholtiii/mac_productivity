#!/bin/sh -eux

../madlab_login.sh

# Here's the URL for the offers
# https://portal.azure.com/#view/Microsoft_Azure_Marketplace/GalleryItemDetailsBladeNopdl/id/redhat.rhel-20190605/selectionMode~/false/resourceGroupId//resourceGroupLocation//dontDiscardJourney~/false/selectedMenuId/home/launchingContext~/%7B%22galleryItemId%22%3A%22redhat.rhel-201906059_2%22%2C%22source%22%3A%5B%22GalleryFeaturedMenuItemPart%22%2C%22VirtualizedTileDetails%22%5D%2C%22menuItemId%22%3A%22home%22%2C%22subMenuItemId%22%3A%22Search%20results%22%2C%22telemetryId%22%3A%220118972e-51ec-46dc-80be-f03acc55e50a%22%7D/searchTelemetryId/4cffa50b-4ab4-46ee-8e46-807819cc0986

# Ask what license model the user wants
function read_license_model()
{
    local default=BYOS
    local completed=0
    local license=
    
    while [[ ${completed} -eq 0 ]]; do
	read -p "What license model do you want to use [BYOS(default), PAYG]: " license
	if [[ "${license}" != "" ]] && [[ "${license}" != "BYOS" ]] && [[ "${license}" != "PAYG" ]]; then
	    echo "Illegal choice '${license}' given!"
	else
	    if [[ "${license}X" == "X" ]]; then
		license=BYOS
	    fi
	    export LICENSE_MODEL=${license}
	    completed=1
	fi
    done
}

# Ask for VM name
function read_vm_name()
{
    local completed=0
    local vm_name=
    
    while [[ ${completed} -eq 0 ]]; do
	read -p "What VM NAME do you want to create: " vm_name
	if [[ "${vm_name}X" == "X" ]]; then
	    echo "Illegal empty name '${vm_name}' given!"
	elif [[ ${#vm_name} -gt 15 ]]; then
	    echo "VM Name must be 15 characters or less!"
	else
	    export VM_NAME=${vm_name}
	    completed=1
	fi
    done
}

# If the image has terms, accept the legal terms for the image we will use
function accept_terms()
{
    local plan=
    
    # If the image has a plan, accept the legal terms for the image we will use
    plan=$(az vm image show --urn "${URN}" --query plan)
    if [[ "${plan}" == "" ]]; then
	echo "Image URN '${URN}' does not require accepting terms"
    else
	az vm image terms accept --urn "${URN}"
    fi
}

read_license_model
read_vm_name

echo "License Model: ${LICENSE_MODEL}"

if [[ "${LICENSE_MODEL}" == "PAYG" ]]; then
    echo "Choosing PAYG options"
    PUBLISHER=RedHat
    OFFER=RHEL
    SKU=8-lvm-gen2
    BICEP=vm-linux-payg.bicep
else
    echo "Choosing BYOS options"
    PUBLISHER=redhat
    OFFER=rhel-byos
    SKU=rhel-lvm89-gen2
    BICEP=vm-linux-byos.bicep
fi
export URN="${PUBLISHER}:${OFFER}:${SKU}:latest"

accept_terms


VM_SUBSCRIPTION=madlab.bwce.io_genpop
VM_SUBSCRIPTION_ID=bb22f549-ff4d-405f-b765-7a2647438259

# Use available resource group, vnet, and subnet resources that are set up for connectivity through the MADLAB VPN EAST Settings
VIRTUAL_NETWORK_RG="spoke01-madlab-eastus2-rg"
# spoke-01-madlab-eastus2-subnet2 is 10.242.201.0/25 - https://portal.azure.com/#@madlab.bwce.io/resource/subscriptions/bb22f549-ff4d-405f-b765-7a2647438259/resourceGroups/spoke01-madlab-eastus2-rg/providers/Microsoft.Network/virtualNetworks/spoke01-madlab-eastus2-vnet/subnets
VIRTUAL_NETWORK_AND_SUBNET="spoke01-madlab-eastus2-vnet/spoke01-madlab-eastus2-subnet2"
VIRTUAL_NETWORK=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $1}')
VIRTUAL_SUBNET=$(echo ${VIRTUAL_NETWORK_AND_SUBNET} | awk -F/ '{print $2}')

SUBNET_ID=$(az network vnet subnet show --resource-group ${VIRTUAL_NETWORK_RG} --name ${VIRTUAL_SUBNET} --vnet-name ${VIRTUAL_NETWORK} --query id -o tsv)

# Note that public IPs are not allowed by policy, but are a required variable upon resource creation, so create an empty resource here.

az deployment sub create --name ${VM_NAME} --template-file ./${BICEP} --location eastus2 --parameters vmName="${VM_NAME}" subnetID=${SUBNET_ID} publisher=${PUBLISHER} offer="${OFFER}" sku="${SKU}" virtualNetworkName=${VIRTUAL_NETWORK}
