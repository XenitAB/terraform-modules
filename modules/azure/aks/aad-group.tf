resource "azurerm_role_assignment" "group_view_aks" {
  for_each             = { for ns in var.namespaces : ns.name => ns }
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.view[each.key].id
}

resource "azurerm_role_assignment" "group_edit_aks" {
  for_each             = { for ns in var.namespaces : ns.name => ns }
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.edit[each.key].id
}

resource "azurerm_role_assignment" "group_cluster_admin_aks" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.cluster_admin.id
}

resource "azurerm_role_assignment" "group_cluster_view_aks" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.cluster_view.id
}
