# Object to enable or disable reading Azure DevOps PAT from Azure KeyVault
variable "azure_devops_pat_keyvault" {
  description = "Object to read Azure DevOps PAT (Personal Access Token) from Azure KeyVault"
  type = object({
    read_azure_devops_pat_from_azure_keyvault = bool
    azure_keyvault_id                         = string
    key                                       = string
  })
}

# If var.azure_devops_pat_keyvault.read_azure_devops_pat_from_azure_keyvault == false, use var.azure_devops_pat instead
variable "azure_devops_pat" {
  description = "Azure DevOps PAT (Personal Access Token)"
  type        = string
  default     = ""
}

# Azure DevOps Configuration
variable "azure_devops_domain" {
  description = "The domain of Azure DevOps"
  type        = string
  default     = "dev.azure.com"
}

# Azure DevOps Proxy Namespace
variable "azdo_proxy_namespace" {
  description = "The namespace to be used by Azure DevOps Proxy"
  type        = string
  default     = "azdo-proxy"
}

# Azure DevOps Proxy Configuration Secret name
variable "azdo_proxy_config_secret_name" {
  description = "The name of the secret storing the azdo-proxy configuration"
  type        = string
  default     = "azdo-proxy-config"
}

# Azure DevOps Proxy Helm Repositroy
variable "azdo_proxy_helm_repository" {
  description = "The helm repository for azdo-proxy"
  type        = string
  default     = "https://xenitab.github.io/azdo-proxy/"
}

# Azure DevOps Proxy Helm Chart name
variable "azdo_proxy_helm_chart_name" {
  description = "The helm chart name for azdo-proxy"
  type        = string
  default     = "azdo-proxy"
}

# Azure DevOps Proxy Helm Chart version
variable "azdo_proxy_helm_chart_version" {
  description = "The helm chart version for azdo-proxy"
  type        = string
  default     = "v0.3.0"
}

# Azure DevOps Organization to use
variable "azure_devops_organization" {
  description = "Azure Devops organization used to configure azdo-proxy"
  type        = string
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
