resource "azurerm_user_assigned_identity" "popeye" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-popeye-wi"
}

resource "azurerm_role_assignment" "aks_contributor" {
  scope                = data.azurerm_storage_account.log.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.aks_managed_identity_id
}

resource "azurerm_role_assignment" "popeye_contributor" {
  scope                = data.azurerm_storage_account.log.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_user_assigned_identity.popeye.principal_id
}

resource "azurerm_federated_identity_credential" "popeye" {
  name                = azurerm_user_assigned_identity.popeye.name
  resource_group_name = azurerm_user_assigned_identity.popeye.resource_group_name
  parent_id           = azurerm_user_assigned_identity.popeye.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:popeye:popeye"
}