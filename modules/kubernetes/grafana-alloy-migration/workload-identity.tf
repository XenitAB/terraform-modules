data "azurerm_user_assigned_identity" "xenit" {
  resource_group_name = var.resource_group_name
  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}-xenit"
}

resource "azurerm_federated_identity_credential" "grafana_alloy" {
  name                = "uai-${var.environment}-${var.location_short}-${var.aks_name}-grafana-alloy-wi"
  resource_group_name = data.azurerm_user_assigned_identity.xenit.resource_group_name
  parent_id           = data.azurerm_user_assigned_identity.xenit.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:grafana-alloy:grafana-alloy"
}
