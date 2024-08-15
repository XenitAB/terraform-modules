data "azuread_service_principal" "owner_spn" {
  display_name = var.owner_service_principal_name
}

resource "azurerm_role_assignment" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Contributor"
  principal_id         = var.azuread_apps.rg_contributor[each.key].service_principal_object_id
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  name = replace(var.azuread_apps.rg_contributor[each.key].display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = var.azuread_apps.rg_contributor[each.key].client_id
    clientSecret   = var.aad_sp_passwords[each.value.common_name]
  })
  key_vault_id = azurerm_key_vault.delegate_kv[var.core_name].id
  content_type = "application/json"

  depends_on = [
    azurerm_key_vault_access_policy.ap_owner_spn
  ]
}
