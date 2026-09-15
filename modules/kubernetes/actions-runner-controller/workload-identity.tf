resource "azurerm_user_assigned_identity" "arc" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-arc-wi"
}

resource "azurerm_federated_identity_credential" "arc" {
  name                = azurerm_user_assigned_identity.arc.name
  resource_group_name = azurerm_user_assigned_identity.arc.resource_group_name
  parent_id           = azurerm_user_assigned_identity.arc.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.arc_config.namespace}:${local.service_account_name}"
}
