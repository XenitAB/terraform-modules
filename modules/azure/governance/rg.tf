resource "azurerm_resource_group" "rg" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
  }

  name     = "rg-${each.value.name}"
  location = each.value.region.location
  tags = merge(
    {
      "Environment"   = each.value.environment,
      "Location"      = each.value.region.location,
      "LocationShort" = each.value.region.locationShort

    },
    each.value.resource_group_config.tags
  )
}
