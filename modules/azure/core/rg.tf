# Add datasource for resource group
data "azurecaf_name" "azurerm_resource_group_this" {
  name          = var.name
  resource_type = "azurerm_resource_group"
  prefixes      = module.names.this.azurerm_resource_group.prefixes
  suffixes      = module.names.this.azurerm_resource_group.suffixes
  use_slug      = false
}

data "azurerm_resource_group" "this" {
  name = data.azurecaf_name.azurerm_resource_group_this.result
}
