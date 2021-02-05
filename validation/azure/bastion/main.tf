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

  name = "rg-test"
}

resource "azurerm_public_ip" "this" {

  name                = "pip-name"
  location            = "we"
  resource_group_name = "rg-name"
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_subnet" "this" {

  name                 = "subnet-name"
  resource_group_name  = "rg-name"
  virtual_network_name = "vnet-name"
  address_prefixes     = "subnet-prefix"
}

resource "azurerm_bastion_host" "this" {

  name                = "bastion-name"
  location            = "we"
  resource_group_name = "rg-name"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "subnet.id"
    public_ip_address_id = "pip.id"
  }
}