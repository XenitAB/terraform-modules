resource "azurerm_network_security_rule" "nsg" {
  for_each = {
    for rule in var.nsg_rules :
    rule.name => rule
    if var.nsg_rules_enabled
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = "nsg-${var.environment}-${var.location_short}-${var.core_name}-${var.name}${var.aks_name_suffix}"
}