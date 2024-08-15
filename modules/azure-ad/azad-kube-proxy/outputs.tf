output "data" {
  description = "The Azure AD Application data for azad-kube-proxy"
  value = {
    client_id     = azuread_application.this.client_id
    client_secret = azuread_application_password.this.value
    tenant_id     = data.azuread_client_config.current.tenant_id
  }
  sensitive = true
}
