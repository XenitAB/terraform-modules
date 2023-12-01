output "key_vault_name" {
  description = "Output each keyvault name"
  value = {
    name = {
      for key, value in azurerm_key_vault.delegate_kv :
      key => {
        name = value.name
      }
    }
  }
}
