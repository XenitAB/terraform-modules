data "azuread_service_principal" "ownerSpn" {
  display_name = var.owner_service_principal_name
}

resource "azuread_application" "aadApp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_principal == true
  }

  name = "${local.spNamePrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscription_name}${local.groupNameSeparator}${var.environment}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}contributor"
}

resource "azuread_service_principal" "aadSp" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_principal == true
  }

  application_id = azuread_application.aadApp[each.key].application_id
}

resource "azurerm_role_assignment" "roleAssignmentSp" {
  for_each = {
    for env_resource in local.env_resources :
    env_resource.name => env_resource
    if env_resource.resource_group_config.delegate_service_principal == true
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aadSp[each.value.resource_group_config.commonName].object_id
}

resource "random_password" "aadSpSecret" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_principal == true
  }
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.aadSp[each.key].id
  }
}

resource "azuread_application_password" "aadSpSecret" {
  for_each = {
    for rg in var.resource_group_configs :
    rg.commonName => rg
    if rg.delegate_service_principal == true
  }
  application_object_id = azuread_application.aadApp[each.key].id
  value                 = random_password.aadSpSecret[each.key].result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

#resource "azurerm_key_vault_secret" "aadSpKvSecret" {
#  for_each = {
#    for env_resourceCoreRg in setproduct(var.resource_group_configs, local.coreRgs) : "${envResourceCoreRg[1]}-${envResourceCoreRg[0].commonName}" => {
#      resource_group_configs = envResourceCoreRg[0]
#      coreRg   = envResourceCoreRg[1]
#    }
#    if envResourceCoreRg[0].delegate_service_principal == true
#  }
#
#  name = replace(azuread_service_principal.aadSp[each.value.resource_group_config.commonName].display_name, ".", "-")
#  value = jsonencode({
#    tenantId       = data.azurerm_subscription.current.tenant_id
#    subscriptionId = data.azurerm_subscription.current.subscription_id
#    clientId       = azuread_service_principal.aadSp[each.value.resource_group_config.commonName].application_id
#    clientSecret   = random_password.aadSpSecret[each.value.resource_group_config.commonName].result
#  })
#  key_vault_id = azurerm_key_vault.delegateKv[each.value.coreRg].id
#
#  depends_on = [
#    azurerm_key_vault_access_policy.delegateKvApOwnerSpn
#  ]
#}
