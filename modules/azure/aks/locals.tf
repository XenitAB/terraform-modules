locals {
  sp_name_prefix       = "sp"
  group_name_separator = "-"
  aad_group_prefix     = "az"
  aks_group_name_prefix = "aks"

  # Namespace to create service accounts in
  service_account_namespace = "service-accounts"
}
