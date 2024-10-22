data "azurerm_resource_group" "tenant" {
  for_each = {
    for ns in var.azure_service_operator_config.tenant_namespaces :
    ns.name => ns
  }

  name = "rg-${var.environment}-${var.location_short}-${each.key}"
}

# The user assigned identities that we create per tenant namespace are by default associated with the 
# resource group of the xks cluster, e.g. 'rg-dev-we-aks', and we want identities that are associated
# with the tenant resource group.
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

# The federated credentials will be used by the ASO operator, hence the subject below.
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
  subject             = "system:serviceaccount:azureserviceoperator-system:azureserviceoperator-default"
}