locals {
  key_vault_rbac_roles_data_access_admin = [
    "Key Vault Data Access Administrator"
  ]

  key_vault_rbac_roles_key = [
    "Key Vault Crypto Officer"
  ]

  key_vault_rbac_roles_secret = [
    "Key Vault Secrets Officer"
  ]

  key_vault_rbac_roles_certificate = [
    "Key Vault Certificates Officer"
  ]

  key_vault_rbac_roles_key_secret = concat(
    local.key_vault_rbac_roles_key,
    local.key_vault_rbac_roles_secret
  )

  key_vault_rbac_roles_key_secret_cert = concat(
    local.key_vault_rbac_roles_key_secret,
    local.key_vault_rbac_roles_certificate
  )

  key_vault_rbac_roles_key_user = [
    "Key Vault Crypto User"
  ]

  key_vault_rbac_roles_secret_user = [
    "Key Vault Secrets User"
  ]

  key_vault_rbac_roles_certificate_user = [
    "Key Vault Certificate User"
  ]

  key_vault_rbac_roles_key_secret_user = concat(
    local.key_vault_rbac_roles_key_user,
    local.key_vault_rbac_roles_secret_user
  )

  key_vault_rbac_roles_key_secret_cert_user = concat(
    local.key_vault_rbac_roles_key_secret_user,
    local.key_vault_rbac_roles_certificate_user
  )

  key_vault_rbac_roles_owner = concat(
    local.key_vault_rbac_roles_data_access_admin,
    local.key_vault_rbac_roles_key_secret_cert
  )

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
    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]
  }

  key_vault_read_permissions = {
    key_permissions = [
      "Get",
      "List"
    ]
    secret_permissions = [
      "Get",
      "List"
    ]
    certificate_permissions = [
      "Get",
      "GetIssuers",
      "List",
      "ListIssuers"
    ]
  }
}
