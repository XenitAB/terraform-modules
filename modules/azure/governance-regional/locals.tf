locals {
  key_vault_rbac_roles = {
    key_secret = [
      "Key Vault Crypto Officer",
      "Key Vault Secrets Officer"
    ]
    key_secret_cert = [
      "Key Vault Crypto Officer",
      "Key Vault Secrets Officer",
      "Key Vault Certificates Officer"
    ]
  }
}
