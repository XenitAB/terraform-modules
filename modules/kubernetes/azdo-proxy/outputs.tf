# Azure DevOps local passwords
output "azdo_proxy_local_passwords" {
  description = "The local passwords for Azure DevOps Proxy"
  value       = { for k, v in random_password.azdo_proxy : k => v.result }
  sensitive   = true
}
