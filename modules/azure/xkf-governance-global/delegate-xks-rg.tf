resource "azuread_group_member" "resource_group_owner" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }
  group_object_id  = azuread_group.edit[each.key].id
  member_object_id = var.azuread_groups.rg_owner[each.key].id
}

resource "azuread_group_member" "resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }
  group_object_id  = azuread_group.edit[each.key].id
  member_object_id = var.azuread_groups.rg_contributor[each.key].id
}

resource "azuread_group_member" "resource_group_reader" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }
  group_object_id  = azuread_group.view[each.key].id
  member_object_id = var.azuread_groups.rg_reader[each.key].id
}
