resource "azurerm_dns_zone" "this" {
  for_each = {
    for dns in var.dns_zone :
    dns => dns
  }
  name                = each.key
  resource_group_name = azurerm_resource_group.this.name
}
