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
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name = "rg-${each.value.name}"
}

resource "azurerm_public_ip" "this" {
  for_each = {
    for subnet in local.bastions :
    subnet.subnet_name => subnet
  }

  name                = "pip-${each.value.vnet_resource}-bastion"
  location            = data.azurerm_resource_group.this[each.value.vnet_resource].location
  resource_group_name = data.azurerm_resource_group.this[each.value.vnet_resource].name
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_subnet" "this" {
  for_each = {
    for subnet in local.bastions :
    subnet.subnet_name => subnet
  }

  name                 = each.value.subnet_name
  resource_group_name  = data.azurerm_resource_group.this[each.value.vnet_resource].name
  virtual_network_name = var.vnet_name
  address_prefixes     = [each.value.subnet_cidr]
}

resource "azurerm_bastion_host" "this" {
  for_each = {
    for subnet in local.bastions :
    subnet.subnet_name => subnet
  }
  name                = "bastion-${each.value.vnet_resource}"
  location            = data.azurerm_resource_group.this[each.value.vnet_resource].location
  resource_group_name = data.azurerm_resource_group.this[each.value.vnet_resource].name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.this[each.key].id
    public_ip_address_id = azurerm_public_ip.this[each.key].id
  }
}