data "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}-${var.location_short}-${var.core_name}"
  resource_group_name = "rg-${var.environment}-${var.location_short}-${var.core_name}"
}

resource "azurerm_role_assignment" "vnet" {
  scope                = data.azurerm_virtual_network.vnet.id
  role_definition_name = "Contributor"
  principal_id         = local.aksAadApps.aksClientAppPrincipalId #FIXME
}
