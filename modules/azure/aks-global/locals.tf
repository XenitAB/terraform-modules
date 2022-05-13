locals {
  aad_groups = {
    view                 = { for k, v in azuread_group.view : k => { id = v.id, name = v.display_name } }
    edit                 = { for k, v in azuread_group.edit : k => { id = v.id, name = v.display_name } }
    cluster_admin        = { id = azuread_group.cluster_admin.id, name = azuread_group.cluster_admin.display_name }
    cluster_view         = { id = azuread_group.cluster_view.id, name = azuread_group.cluster_view.display_name }
    aks_managed_identity = { id = azuread_group.aks_managed_identity.id, name = azuread_group.aks_managed_identity.display_name }
  }
}
