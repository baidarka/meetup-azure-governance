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
resource "azurerm_resource_group" "meetup" {
  name     = "rg-euw-meetup-dev-001"
  location = "West Europe"
  tags = {
    costCenter  = "42-demo",
    projectName = "MeetUp"
  }
}

resource "azurerm_storage_account" "compliant" {
  name                = "stgdemocompliant"
  resource_group_name = "${azurerm_resource_group.meetup.name}"
  location            = "${azurerm_resource_group.meetup.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "https" {
  name                = "stgdemohttps"
  resource_group_name = "${azurerm_resource_group.meetup.name}"
  location            = "${azurerm_resource_group.meetup.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "network" {
  name                = "stgdemonetwork"
  resource_group_name = "${azurerm_resource_group.meetup.name}"
  location            = "${azurerm_resource_group.meetup.location}"
  account_tier        = "Standard"

  account_replication_type = "LRS"
}