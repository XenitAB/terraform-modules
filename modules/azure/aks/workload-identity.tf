resource "azurerm_user_assigned_identity" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-${each.key}-wi"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
}

data "azuread_group" "tenant_resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}contributor"
}

resource "azuread_group_member" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  group_object_id  = data.azuread_group.tenant_resource_group_contributor[each.key].id
  member_object_id = azurerm_user_assigned_identity.tenant[each.key].principal_id
}

resource "azurerm_federated_identity_credential" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  name                = azurerm_user_assigned_identity.tenant[each.key].name
  resource_group_name = azurerm_user_assigned_identity.tenant[each.key].resource_group_name
  parent_id           = azurerm_user_assigned_identity.tenant[each.key].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:${each.key}:${each.key}"
}
