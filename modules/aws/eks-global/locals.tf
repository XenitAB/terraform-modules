locals {
  aad_groups = {
    view          = { for k, v in azuread_group.view : k => { id = v.id, name = v.name } }
    edit          = { for k, v in azuread_group.edit : k => { id = v.id, name = v.name } }
    cluster_admin = { id = azuread_group.cluster_admin.id, name = azuread_group.cluster_admin.name }
    cluster_view  = { id = azuread_group.cluster_view.id, name = azuread_group.cluster_view.name }
  }
}
