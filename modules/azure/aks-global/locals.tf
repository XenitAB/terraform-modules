locals {
  service_principal_name_prefix = "sp"
  group_name_separator          = "-"
  azure_ad_group_prefix         = "az"
  aks_group_name_prefix         = "aks"
  aks_public_ip_prefixes        = [for prefix in azurerm_public_ip_prefix.aks : prefix.ip_prefix]
  aad_pod_identity = {
  for k, v in azurerm_user_assigned_identity.aad_pod_identity :
    k => {id = v.id, client_id = v.client_id}
  }
}
