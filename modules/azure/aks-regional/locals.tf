locals {
  aks_public_ip_prefix_ids  = [for prefix in azurerm_public_ip_prefix.aks : prefix.id]
  aks_public_ip_prefix_ips  = [for prefix in azurerm_public_ip_prefix.aks : prefix.ip_prefix]
  aks_public_ip_preifx_name = var.public_ip_prefix_name_override == "" ? "pip-prefix-${var.environment}-${var.location_short}-${var.name}-aks" : var.public_ip_prefix_name_override
  aad_pod_identity = {
    for k, v in azurerm_user_assigned_identity.aad_pod_identity :
    k => { id = v.id, client_id = v.client_id }
  }

  key_vault_default_permissions = {
    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]
    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]
  }
}
