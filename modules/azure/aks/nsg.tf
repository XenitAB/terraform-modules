data "azurerm_resources" "public_ips" {
  count               = var.add_default_security_lb_rule ? 1 : 0
  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  type                = "Microsoft.Network/publicIPAddresses"
}


resource "azurerm_network_security_rule" "allow_internet_azure_lb" {
  count                       = var.add_default_security_lb_rule ? 1 : 0
  name                        = "aks-allow-internet-to-azure-lb"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80,443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = data.azurerm_resources.public_ips
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = "nsg-${var.environment}-${var.location_short}-${var.core_name}-${var.name}${var.aks_name_suffix}"
}

resource "azurerm_network_security_rule" "additonal_security_rules" {
  for_each = {
    for rule in var.additonal_security_rules :
    rule.name => rule
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
