# Add datasource for resource group
data "azurerm_resource_group" "rg" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name = "rg-${each.value.name}"
}
