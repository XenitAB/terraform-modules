output "virtual_network" {
  description = "Output for Azure Virtual Network"
  value       = azurerm_virtual_network.this
}

output "subnets" {
  description = "Output for Azure Virtual Network Subnets"
  value = {
    this = azurerm_subnet.this
    aks  = azurerm_subnet.aks
  }
}

output "route_tables" {
  description = "Output for Azure Routing Tables"
  value       = azurerm_route_table.this
}

output "network_security_groups" {
  description = "Output for Azure Network Security Groups"
  value       = azurerm_network_security_group.this
}
