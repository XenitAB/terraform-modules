resource "azurerm_user_assigned_identity" "cert_manager" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-cert-manager-wi"
}

resource "azurerm_role_assignment" "cert_manager_contributor" {
  for_each = {
    for dns in var.dns_zones :
    dns => dns
    if var.rbac_create
  }
  scope                = each.key
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}

resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = azurerm_user_assigned_identity.cert_manager.name
  resource_group_name = azurerm_user_assigned_identity.cert_manager.resource_group_name
  parent_id           = azurerm_user_assigned_identity.cert_manager.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:cert-manager:cert-manager"
}