data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.aks_name}"
}

data "azurerm_resource_group" "tenant" {
  for_each = {
    for ns in var.azure_service_operator_config.tenant_namespaces :
    ns.name => ns
  }

  name = "rg-${var.environment}-${var.location_short}-${each.key}"
}

resource "azurerm_user_assigned_identity" "azure_service_operator" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-azure-service-operator-wi"
}

resource "azurerm_role_assignment" "azure_service_operator_contributor" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.azure_service_operator.principal_id
}

resource "azurerm_federated_identity_credential" "azure_service_operator" {
  name                = azurerm_user_assigned_identity.azure_service_operator.name
  resource_group_name = azurerm_user_assigned_identity.azure_service_operator.resource_group_name
  parent_id           = azurerm_user_assigned_identity.azure_service_operator.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:azureserviceoperator-system:azureserviceoperator-default"
}

# The user assigned identities that we create by default are assigned the resource group of the xks cluster
# e.g. rg-dev-we-aks, and we want identities that are tied to the tenant resource group instead
resource "azurerm_user_assigned_identity" "tenant" {
  for_each = {
    for ns in var.azure_service_operator_config.tenant_namespaces :
    ns.name => ns
  }

  resource_group_name = "rg-${var.environment}-${var.location_short}-${each.key}"
  location            = var.location
  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}${local.aks_name_suffix}-${each.key}-aso"
}

resource "azurerm_role_assignment" "tenant_contributor" {
  for_each = {
    for ns in var.azure_service_operator_config.tenant_namespaces :
    ns.name => ns
  }

  scope                = data.azurerm_resource_group.tenant[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.tenant[each.key].principal_id
}

resource "azurerm_federated_identity_credential" "tenant" {
  for_each = {
    for ns in var.azure_service_operator_config.tenant_namespaces :
    ns.name => ns
  }

  name                = azurerm_user_assigned_identity.tenant[each.key].name
  resource_group_name = azurerm_user_assigned_identity.tenant[each.key].resource_group_name
  parent_id           = azurerm_user_assigned_identity.tenant[each.key].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${each.key}:${each.key}"
}