resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_key_vault_secret" "ssh_key" {
  name         = "ssh-priv-aks-${var.environment}-${var.location_short}"
  value        = jsonencode(tls_private_key.ssh_key)
  key_vault_id = data.azurerm_key_vault.core.id
}
