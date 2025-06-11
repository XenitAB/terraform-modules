locals {
  application_namespaces = format("%s-*", join("-*, ", [for s in var.argocd_config.azure_tenants : s.tenant_name]))

  key_vault_default_permissions = {
    key_permissions = [
      "Decrypt",
      "Get",
      "List",
      "UnwrapKey",
      "Verify",
    ]
    secret_permissions = [
      "Get",
      "List",
    ]
  }

  key_vault_secret_names = distinct(flatten([
    for azure_tenant in var.argocd_config.azure_tenants : [
      for cluster in azure_tenant.clusters : [
        for tenant in cluster.tenants : [
          tenant.secret_name
        ]
      ]
    ]
  ]))

  key_vault_secret_values = [
    for secret in local.key_vault_secret_names :
    {
      name : secret
      value : data.azurerm_key_vault_secret.pat[secret].value
    }
  ]
}