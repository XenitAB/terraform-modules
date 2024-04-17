output "aad_groups" {
  description = "Azure AD groups"
  value = {
    view                 = { for k, v in data.azuread_group.view : k => { id = v.id, name = v.display_name } }
    edit                 = { for k, v in data.azuread_group.edit : k => { id = v.id, name = v.display_name } }
    cluster_admin        = { id = data.azuread_group.cluster_admin.id, name = data.azuread_group.cluster_admin.display_name }
    cluster_view         = { id = data.azuread_group.cluster_view.id, name = data.azuread_group.cluster_view.display_name }
    aks_managed_identity = { id = data.azuread_group.aks_managed_identity["aks"].id, name = data.azuread_group.aks_managed_identity["aks"].display_name }
  }
}
