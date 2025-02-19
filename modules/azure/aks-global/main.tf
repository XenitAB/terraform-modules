terraform {
  required_version = ">= 1.1.7"
  required_providers {
    azurerm = {
      version = "4.19.0"
      source  = "hashicorp/azurerm"
    }
    azuread = {
      version = "2.50.0"
      source  = "hashicorp/azuread"
    }
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.environment}-${var.location_short}-global"
  location = var.location
  tags = {
    "Environment"   = var.environment,
    "LocationShort" = var.location_short,
    "description"   = "Global resources",
  }
}

resource "azurerm_management_lock" "rg" {
  for_each = {
    for l in ["rg-global"] :
    l => l
    if var.lock_resource_group
  }

  name       = "DoNotDelete"
  scope      = azurerm_resource_group.this.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can't be deleted without first removing the lock."
}
