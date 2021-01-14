terraform {
  required_version = ">=0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.35.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
}

locals {
  resource_group_name = var.resource_group_name == "" ? "rg-${var.environment}-${var.location_short}-${var.name}" : var.resource_group_name
  custom_data                             = templatefile("${path.module}/templates/cloud-init.tpl", {
    username = azurerm_postgresql_server.controller.administrator_login,
    password = random_password.controller.result,
    server = "",
    database = ""
  })
}

data "azurerm_subscription" "this" {}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

data "azurerm_image" "this" {
  name                = var.boundary_image_name
  resource_group_name  = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  name                 = var.vmss_subnet_config.name
  virtual_network_name = var.vmss_subnet_config.virtual_network_name
  resource_group_name  = var.vmss_subnet_config.resource_group_name
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
