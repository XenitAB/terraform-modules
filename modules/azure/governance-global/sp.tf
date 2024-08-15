data "azuread_service_principal" "owner_spn" {
  display_name = var.owner_service_principal_name
}

data "azuread_application" "owner_spn" {
  display_name = var.owner_service_principal_name
}

resource "azuread_application_password" "owner_spn" {
  for_each = {
    for s in ["pal"] :
    s => s
    if var.partner_id != ""
  }

  application_id = data.azuread_application.owner_spn.id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "pal_management_partner" "owner_spn" {
  depends_on = [azuread_application_password.owner_spn]

  for_each = {
    for s in ["pal"] :
    s => s
    if var.partner_id != ""
  }

  tenant_id     = data.azurerm_subscription.current.tenant_id
  client_id     = data.azuread_service_principal.owner_spn.client_id
  client_secret = azuread_application_password.owner_spn["pal"].value
  partner_id    = var.partner_id
  overwrite     = true
}

data "azurecaf_name" "azuread_application_aad_app" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  name          = each.key
  resource_type = "general"
  separator     = var.group_name_separator
  prefixes      = module.names.this.azuread_application_rg.prefixes
  suffixes      = concat(module.names.this.azuread_application_rg.suffixes, ["contributor"])
  use_slug      = false
}

resource "azuread_application" "aad_app" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  display_name = data.azurecaf_name.azuread_application_aad_app[each.key].result
}

resource "azuread_service_principal" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  client_id = azuread_application.aad_app[each.key].client_id
}

resource "azuread_application_password" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  application_id = azuread_application.aad_app[each.key].id
  end_date       = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}


resource "pal_management_partner" "aad_sp" {
  depends_on = [azuread_application_password.aad_sp]

  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true && var.partner_id != ""
  }

  tenant_id     = data.azurerm_subscription.current.tenant_id
  client_id     = azuread_application.aad_app[each.key].client_id
  client_secret = azuread_application_password.aad_sp[each.key].value
  partner_id    = var.partner_id
  overwrite     = true
}
