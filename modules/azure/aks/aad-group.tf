resource "azurerm_role_assignment" "view" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = azurerm_kubernetes_cluster.this.id
  principal_id         = var.aad_groups.view[each.key].id
}

resource "azurerm_role_assignment" "edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = azurerm_kubernetes_cluster.this.id
  principal_id         = var.aad_groups.edit[each.key].id
}

resource "azurerm_role_assignment" "cluster_admin" {
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  scope                = azurerm_kubernetes_cluster.this.id
  principal_id         = var.aad_groups.cluster_admin.id
}

resource "azurerm_role_assignment" "cluster_view" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster View Role"
  principal_id         = var.aad_groups.cluster_view.id
}

resource "azuread_group_member" "aks_managed_identity" {
  group_object_id  = var.aad_groups.aks_managed_identity.id
  member_object_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
