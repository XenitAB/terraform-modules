locals {
  env_resources = { for p in setproduct(var.resource_group_configs, var.regions) : "${var.environment}-${p[1].location_short}-${p[0].common_name}" => {
    name                  = "${var.environment}-${p[1].location_short}-${p[0].common_name}"
    environment           = var.environment
    resource_group_config = p[0]
    region                = p[1]
    }
  }
  core_rgs              = [for region in var.regions : "${var.environment}-${region.location_short}-${var.core_name}"]
  group_name_separator  = "-"
  aad_group_prefix      = "az"
  sp_name_prefix        = "sp"
  aks_group_name_prefix = "aks"


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
}
