resource "azuread_application" "aadAppHelmOperator" {
  name = "${local.spNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${var.aksCommonName}${local.groupNameSeparator}helmoperator"
}

resource "azuread_service_principal" "aadAppHelmOperator" {
  application_id = azuread_application.aadAppHelmOperator.application_id
}

resource "random_password" "aadAppHelmOperator" {
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.aadAppHelmOperator.id
  }
}

resource "azuread_application_password" "aadAppHelmOperator" {
  application_object_id = azuread_application.aadAppHelmOperator.id
  value                 = random_password.aadAppHelmOperator.result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "azuread_group_member" "aadGroupMemberAcrPullHelmOperator" {
  group_object_id  = data.azuread_group.aadGroupAcrPull.id
  member_object_id = azuread_service_principal.aadAppHelmOperator.object_id
}

resource "azurerm_key_vault_secret" "kvSecretHelmOperator" {
  name = "helm-operator"
  value = jsonencode({
    client_id = azuread_service_principal.aadAppHelmOperator.application_id
    secret    = random_password.aadAppHelmOperator.result
  })
  key_vault_id = data.azurerm_key_vault.coreKv.id
}
