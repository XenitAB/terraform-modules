# Namespace configuration
variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name = string
      flux = object({
        enabled      = bool
        azdo_org     = string
        azdo_project = string
        azdo_repo    = string
      })
    })
  )
}

# Should FluxCD integrate with Azure DevOps Proxy
variable "azdo_proxy_enabled" {
  description = "Should azdo-proxy integration be enabled"
  type        = bool
  default     = true
}

# Azure DevOps Proxy local passwords
variable "azdo_proxy_local_passwords" {
  description = "The passwords (per namespace) to communicate with Azure DevOps Proxy"
  type        = map(string)
  default     = {}
}

# Helm Operator Credentials for Azure Container Registry
variable "helm_operator_credentials" {
  description = "ACR credentials pased to Helm Operator"
  type = object({
    client_id = string
    secret    = string
  })
}

# Azure Container Registry name
variable "acr_name" {
  description = "Name of ACR registry to use for cluster"
  type        = string
}
