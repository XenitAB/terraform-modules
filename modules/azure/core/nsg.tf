data "azurecaf_name" "azurerm_network_security_group_this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_create_nsg == true
  }

  name          = each.value.subnet_short_name
  resource_type = "azurerm_network_security_group"
  prefixes      = concat(module.names.this.azurerm_network_security_group.prefixes, [var.name])
  suffixes      = module.names.this.azurerm_network_security_group.suffixes
  use_slug      = false
}

resource "azurerm_network_security_group" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_create_nsg == true
  }

  name                = data.azurecaf_name.azurerm_network_security_group_this[each.key].result
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
    if subnet.subnet_create_nsg == true
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_network_security_rule" "this" {
  for_each = {
    for security_rule in local.security_rules :
    security_rule.rule_name => security_rule
    if security_rule.subnet_create_nsg == true
  }

  name                        = each.value.rule_name
  priority                    = each.value.rule_priority
  direction                   = each.value.rule_direction
  access                      = each.value.rule_access
  protocol                    = each.value.rule_protocol
  source_port_range           = each.value.rule_source_port_range
  destination_port_range      = each.value.rule_destination_port_range
  source_address_prefix       = each.value.rule_source_address_prefix
  destination_address_prefix  = each.value.rule_destination_address_prefix
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this[data.azurecaf_name.azurerm_network_security_group_this[each.value.rule_subnet_full_name].result].name
}