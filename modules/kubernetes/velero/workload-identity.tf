resource "azurerm_user_assigned_identity" "velero" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-velero-wi"
}

resource "azurerm_federated_identity_credential" "velero" {
  name                = azurerm_user_assigned_identity.velero.name
  resource_group_name = azurerm_user_assigned_identity.velero.resource_group_name
  parent_id           = azurerm_user_assigned_identity.velero.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:velero:velero"
}

resource "azurerm_role_assignment" "velero_msi" {
  scope                = azurerm_user_assigned_identity.velero.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_managed_identity
}

resource "azurerm_role_assignment" "external_storage_contributor" {
  scope                = azurerm_storage_account.velero.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "velero_rg_read" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}