# !! Requires Azure CLI !! 
# 
# To use this file, run these commands:
# terraform init
# terraform plan
# terraform apply

####################################################################
## Providers
provider "azurerm" {
  version = "~> 1.36"
}

####################################################################
## Resources

resource "random_integer" "st_num" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "meetup" {
  name     = "rg-euw-meetup-demo"
  location = "West Europe"
  tags = {
    costCenter  = "42-demo",
    projectName = "MeetUp"
  }
}

resource "azurerm_storage_account" "compliant" {
  name                = "stdemocompliant${random_integer.st_num}"
  resource_group_name = "${azurerm_resource_group.meetup.name}"
  location            = "${azurerm_resource_group.meetup.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "https" {
  name                = "stdemohttps${random_integer.st_num}"
  resource_group_name = "${azurerm_resource_group.meetup.name}"
  location            = "${azurerm_resource_group.meetup.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "network" {
  name                = "stdemonetwork${random_integer.st_num}"
  resource_group_name = "${azurerm_resource_group.meetup.name}"
  location            = "${azurerm_resource_group.meetup.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}