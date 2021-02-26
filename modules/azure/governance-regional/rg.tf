resource "azurerm_resource_group" "rg" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
  }

  name     = "rg-${var.environment}-${var.location_short}-${each.value.common_name}"
  location = var.location
  tags = merge(
    {
      "Environment"   = var.environment,
      "LocationShort" = var.location_short

    },
    each.value.tags
  )
}

resource "azurerm_management_lock" "rg" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.lock_resource_group
  }

  name       = "DoNotDelete"
  scope      = azurerm_resource_group.rg[each.key].id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group can't be deleted without first removing the lock."
}
