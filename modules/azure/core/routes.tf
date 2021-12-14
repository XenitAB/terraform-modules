resource "azurerm_route_table" "this" {
  for_each = {
    for route in var.route_config :
    route.subnet_name => route
  }

  name                = "rt-${var.environment}-${var.location_short}-${var.name}-${each.value.subnet_name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_route" "this" {
  for_each = {
    for route in local.routes :
    route.name => route
    if route.next_hop_type == "VirtualAppliance"
  }

  name                   = each.value.route.name
  resource_group_name    = data.azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.this[each.value.subnet_name].name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = each.value.route.next_hop_in_ip_address
}

# Note: In the future, we shouldn't use negated names but we have to do this
#       for now until `move` is supported (when we've updated to 1.1.0 or later):
#       https://github.com/hashicorp/terraform/releases/tag/v1.1.0
resource "azurerm_route" "not_virtual_appliance" {
  for_each = {
    for route in local.routes :
    route.name => route
    if route.next_hop_type != "VirtualAppliance"
  }

  name                = each.value.route.name
  resource_group_name = data.azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this[each.value.subnet_name].name
  address_prefix      = each.value.route.address_prefix
  next_hop_type       = each.value.route.next_hop_type
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for route in local.routes :
    route.name => route
  }

  subnet_id      = azurerm_subnet.this["sn-${var.environment}-${var.location_short}-${var.name}-${each.value.subnet_name}"].id
  route_table_id = azurerm_route_table.this[each.value.subnet_name].id
}