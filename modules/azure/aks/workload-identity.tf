resource "azurerm_user_assigned_identity" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
  }

  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-${each.key}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
}

data "azuread_group" "tenant_resource_group_contributor" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
  }

  display_name = "${var.azure_ad_group_prefix}${var.group_name_separator}rg${var.group_name_separator}${var.subscription_name}${var.group_name_separator}${var.environment}${var.group_name_separator}${each.key}${var.group_name_separator}contributor"
}

resource "azuread_group_member" "tenant" {
  for_each = {
    for ns in var.namespaces :
    ns.name => ns
    if ns.delegate_resource_group == true
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

data "azurerm_resource_group" "global" {
  name = "rg-${var.environment}-${var.global_location_short}-global"
}

data "azurerm_dns_zone" "this" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
  }
  name                = each.key
  resource_group_name = data.azurerm_resource_group.global.name
}

resource "azurerm_user_assigned_identity" "cert_manager" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "uai-${var.environment}-${var.location_short}-${var.name}${local.aks_name_suffix}-cert-manager"
}

resource "azurerm_role_assignment" "cert_manager_contributor" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
  }
  scope                = data.azurerm_dns_zone.this[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}

resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = azurerm_user_assigned_identity.cert_manager.name
  resource_group_name = azurerm_user_assigned_identity.cert_manager.resource_group_name
  parent_id           = azurerm_user_assigned_identity.cert_manager.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:cert-manager:cert-manager"
}
