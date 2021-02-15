/**
  * # Hub
  *
  * This module is used to create a Azure Bastion host in production subscription.
  * 
  * ## Usage
  *
  * Use together with the `hub` module to create a Azure Bastion host.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.35.0"
      source  = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}

resource "azurerm_public_ip" "this" {
  name                = "pip-${var.environment}-${var.location_short}-${var.name}-bastion"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_subnet" "this" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.bastion_subnet_config.cidr
}

resource "azurerm_bastion_host" "this" {
  name                = "bastion-${var.environment}-${var.location_short}-${var.name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.this.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}