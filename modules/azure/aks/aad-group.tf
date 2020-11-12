resource "azurerm_role_assignment" "groupViewAksAssignment" {
  for_each             = { for ns in local.k8sNamespaces : ns.name => ns }
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = local.aadGroups.aadGroupView[each.key].id
}

resource "azurerm_role_assignment" "groupEditAksAssignment" {
  for_each             = { for ns in local.k8sNamespaces : ns.name => ns }
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = local.aadGroups.aadGroupEdit[each.key].id
}

resource "azurerm_role_assignment" "groupClusterAdminAksAssignment" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = local.aadGroups.aadGroupClusterAdmin.id
}

resource "azurerm_role_assignment" "groupClusterViewAksAssignment" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = local.aadGroups.aadGroupClusterView.id
}
