resource "azurerm_network_security_rule" "nsg" {
  for_each = {
    for rule in var.nsg_rules :
    rule.name => rule
    if var.nsg_rules_enabled
  }

  name                        = each.value.rule.name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = "nsg-${var.environment}-${var.location_short}-${var.core_name}-${var.name}${var.aks_name_suffix}"
}