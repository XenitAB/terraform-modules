resource "tls_private_key" "sshKey" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_key_vault_secret" "secretSshKey" {
  name         = "ssh-priv-aks-${var.environmentShort}-${var.locationShort}"
  value        = jsonencode(tls_private_key.sshKey)
  key_vault_id = data.azurerm_key_vault.coreKv.id
}
