resource "azurerm_role_assignment" "view" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.view[each.key].id
}

resource "azurerm_role_assignment" "edit" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.edit[each.key].id
}

resource "azurerm_role_assignment" "cluster_admin" {
  scope = azurerm_kubernetes_cluster.this.id

  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.cluster_admin.id
}

resource "azurerm_role_assignment" "cluster_view" {
  scope = azurerm_kubernetes_cluster.this.id

  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aad_groups.cluster_view.id
}

resource "azuread_group_member" "aks_managed_identity" {
  group_object_id  = var.aad_groups.aks_managed_identity.id
  member_object_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

# This is a work around to stop any update of the AKS cluster to force a recreation of the role assignments.
# The reason this works is a bit tricky, but it gets Terraform to not reload the resource group data source.
# https://github.com/hashicorp/terraform-provider-azurerm/issues/15557#issuecomment-1050654295
locals {
  node_resource_group = azurerm_kubernetes_cluster.this.node_resource_group
}

data "azurerm_resource_group" "aks" {
  name = local.node_resource_group
}

resource "azurerm_role_assignment" "aks_managed_identity_noderg_managed_identity_operator" {
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aad_groups.aks_managed_identity.id
}

resource "azurerm_role_assignment" "aks_managed_identity_noderg_virtual_machine_contributor" {
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = var.aad_groups.aks_managed_identity.id
}
