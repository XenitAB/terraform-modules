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

  application_object_id = data.azuread_application.owner_spn.object_id
  end_date              = timeadd(timestamp(), "87600h") # 10 years

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
  client_id     = data.azuread_service_principal.owner_spn.application_id
  client_secret = azuread_application_password.owner_spn["pal"].value
  partner_id    = var.partner_id
  overwrite     = true
}

resource "azuread_application" "aad_app" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  display_name = "${var.service_principal_name_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.value.common_name}${var.group_name_separator}contributor"
}

resource "azuread_service_principal" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  application_id = azuread_application.aad_app[each.key].application_id
}

resource "azuread_application_password" "aad_sp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.common_name => rg
    if rg.delegate_service_principal == true
  }

  application_object_id = azuread_application.aad_app[each.key].object_id
  end_date              = timeadd(timestamp(), "87600h") # 10 years

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
  client_id     = azuread_application.aad_app[each.key].application_id
  client_secret = azuread_application_password.aad_sp[each.key].value
  partner_id    = var.partner_id
  overwrite     = true
}
