data "azurerm_key_vault_secret" "secretSshKey" {
  name         = "ssh-priv-aks-${var.environmentShort}-${var.locationShort}"
  key_vault_id = data.azurerm_key_vault.coreKv.id
}
