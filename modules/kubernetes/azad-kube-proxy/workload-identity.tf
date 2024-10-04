resource "azurerm_user_assigned_identity" "azad_kube_proxy" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "uai-${var.cluster_id}-azad-kube-proxy-wi"
}

resource "azurerm_federated_identity_credential" "azad_kube_proxy" {
  name                = azurerm_user_assigned_identity.azad_kube_proxy.name
  resource_group_name = azurerm_user_assigned_identity.azad_kube_proxy.resource_group_name
  parent_id           = azurerm_user_assigned_identity.azad_kube_proxy.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:azad-kube-proxy:azad-kube-proxy"
}

resource "azurerm_key_vault_access_policy" "azad_kube_proxy" {
  key_vault_id       = var.key_vault_id
  tenant_id          = azurerm_user_assigned_identity.azad_kube_proxy.tenant_id
  object_id          = azurerm_user_assigned_identity.azad_kube_proxy.principal_id
  secret_permissions = ["Get"]
}