output "subnets" {
  description = "Subnet information"
  value       = azurerm_subnet.this
}

output "resource_groups" {
  description = "Resource group information"
  value       = data.azurerm_resource_group.this
}

output "virtual_networks" {
  description = "Virtual network information"
  value       = azurerm_virtual_network.this
}

output "public_ip_prefixes" {
  description = "Public IP prefix information"
  value       = azurerm_public_ip_prefix.this
}
