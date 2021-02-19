data "azuread_service_principal" "owner_spn" {
  display_name = var.owner_service_principal_name
}

data "azuread_application" "aad_app" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  display_name = "${var.service_principal_name_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}contributor"
}

data "azuread_service_principal" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  application_id = data.azuread_application.aad_app[each.key].application_id
}

resource "random_password" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = data.azuread_service_principal.aad_sp[each.key].id
  }
}

resource "azuread_application_password" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  application_object_id = data.azuread_application.aad_app[each.key].id
  value                 = random_password.aad_sp[each.key].result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}


resource "azurerm_role_assignment" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.aad_sp[each.value.resource_group_config.common_name].object_id
}

resource "pal_management_partner" "aad_sp" {
  depends_on = [azuread_application_password.aad_sp]

  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true && var.partner_id != ""
  }

  tenant_id     = data.azurerm_subscription.current.tenant_id
  client_id     = data.azuread_service_principal.aad_sp[each.key].application_id
  client_secret = random_password.aad_sp[each.key].result
  partner_id    = var.partner_id
  overwrite     = true
}

resource "azurerm_key_vault_secret" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  name = replace(data.azuread_service_principal.aad_sp[each.value.common_name].display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = data.azuread_service_principal.aad_sp[each.value.common_name].application_id
    clientSecret   = random_password.aad_sp[each.value.common_name].result
  })
  key_vault_id = azurerm_key_vault.delegate_kv[var.core_name].id

  depends_on = [
    azurerm_key_vault_access_policy.ap_owner_spn
  ]
}
