/**
  * # Windows Virtual Desktop
  *
  * This module is used to create Windows Virtual Desktop.
  */

terraform {
  required_version = "0.13.5"

  required_providers {
    azurerm = {
      version = "2.47.0"
      source  = "hashicorp/azurerm"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.name}"
}

resource "azurerm_virtual_desktop_host_pool" "this" {
  name                = "pool-${var.environment}-${var.location_short}-${var.name}${var.wvd_name_suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  type               = var.wvd_config.pool_type
  load_balancer_type = var.wvd_config.load_balancer_type
}

resource "azurerm_virtual_desktop_application_group" "this" {
  name                = "acctag"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  type          = "RemoteApp"
  host_pool_id  = azurerm_virtual_desktop_host_pool.this.id
  friendly_name = "TestAppGroup"
  description   = "Acceptance Test: An application group"
}
