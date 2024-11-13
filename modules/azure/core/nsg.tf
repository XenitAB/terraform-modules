data "azurecaf_name" "azurerm_network_security_group_this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
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
  }

  name                = data.azurecaf_name.azurerm_network_security_group_this[each.key].result
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for subnet in local.subnets :
    subnet.subnet_full_name => subnet
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}
