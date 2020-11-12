locals {
  sp_name_prefix       = "sp"
  group_name_separator = "-"
  aad_group_prefix     = "az"
  aks_group_name_prefix = "aks"
  #aksAadApps = {
  #  aksClientAppClientId     = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppClientId
  #  aksClientAppPrincipalId  = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppPrincipalId
  #  aksClientAppClientSecret = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppClientSecret
  #  aksServerAppClientId     = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksServerAppClientId
  #  aksServerAppClientSecret = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksServerAppClientSecret
  #}
  #aadGroups        = data.terraform_remote_state.aksGlobal.outputs.aadGroups
  #aadPodIdentity   = data.terraform_remote_state.aksGlobal.outputs.aadPodIdentity

  # Namespace to create service accounts in
  service_account_namespace = "service-accounts"
}
