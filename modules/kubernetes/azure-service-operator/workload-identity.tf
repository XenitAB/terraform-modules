data "azurerm_resource_group" "this" {
  name = "rg-${var.environment}-${var.location_short}-${var.aks_name}"
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

data "azurerm_user_assigned_identity" "tenant" {
  for_each = {
    for ns in var.azure_service_operator_config.tenant_namespaces :
    ns.name => ns
  }

  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}${local.aks_name_suffix}-${each.key}-wi"
  resource_group_name = "rg-${var.environment}-${var.location_short}-${each.key}"
}