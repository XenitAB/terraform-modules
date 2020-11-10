environment = "foo"

regions = [
  {
    location      = "West Europe"
    locationShort = "we"
  }
]

subscription_name    = "xks"
core_name            = "xkscore"
owner_service_principal_name = "sp-sub-xks-all-owner"

key_vault_default_permissions = {
  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]
  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]
}

resource_group_configs = [
  {
    common_name  = "xkscore",
    delegate_aks = false,
    delegate_key_vault  = true,
    delegate_service_endpoint  = false,
    delegate_service_principal  = false,
    tags = {
      "description" = "Core infrastructure"
    }
  },
]
