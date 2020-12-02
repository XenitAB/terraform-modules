locals {
  aks_public_ip_prefix_ids = [for prefix in azurerm_public_ip_prefix.aks : prefix.id]
  aks_public_ip_prefix_ips = [for prefix in azurerm_public_ip_prefix.aks : prefix.ip_prefix]
  aad_pod_identity = {
    for k, v in azurerm_user_assigned_identity.aad_pod_identity :
    k => { id = v.id, client_id = v.client_id }
  }
  aad_groups = {
    view                 = { for k, v in azuread_group.view : k => { id = v.id, name = v.name } }
    edit                 = { for k, v in azuread_group.edit : k => { id = v.id, name = v.name } }
    cluster_admin        = { id = azuread_group.cluster_admin.id, name = azuread_group.cluster_admin.name }
    cluster_view         = { id = azuread_group.cluster_view.id, name = azuread_group.cluster_view.name }
    aks_managed_identity = { id = azuread_group.aks_managed_identity.id, name = azuread_group.aks_managed_identity.name }
  }
}
