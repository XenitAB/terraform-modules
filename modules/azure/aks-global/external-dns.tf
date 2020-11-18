resource "azurerm_dns_zone" "this" {
  name                = var.dns_zone
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "external_dns" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  name = "uai-${var.environment_short}-${var.location_short}-${var.name}-externaldns"
}

#resource "azurerm_role_assignment" "external_dns" {
#  scope                = azurerm_user_assigned_identity.external_dns.id
#  role_definition_name = "Managed Identity Operator"
#  principal_id         = local.aksAadApps.aksClientAppPrincipalId
#}

#resource "azurerm_role_assignment" "external_dns" {
#  scope                = azurerm_dns_zone.external_dns.id
#  role_definition_name = "Contributor"
#  principal_id         = azuread_service_principal.external_dns.object_id
#}

#resource "azurerm_role_assignment" "version_checker_acr" {
#  scope                = azurerm_container_registry.acr.id
#  role_definition_name = "Owner"
#  principal_id         = azurerm_user_assigned_identity.version_checker.principal_id
#}

data "azuread_group" "lab_view" {
  name = "aks-${var.subscriptionCommonName}-${var.environmentShort}-lab-view"
}

resource "azuread_group_member" "external_dns" {
  group_object_id  = data.azuread_group.lab_view.id
  member_object_id = azurerm_user_assigned_identity.version_checker.principal_id
}
