# FluxCD v1 Helm Chart version
variable "fluxcd_v1_git_path" {
  description = "The git path for fluxcd-v1"
  type        = string
  default     = ""
}

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
