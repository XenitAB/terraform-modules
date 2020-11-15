# Helm Operator Helm release name
variable "helm_operator_helm_release_name" {
  description = "The helm release name for helm-operator"
  type        = string
  default     = "helm-operator"
}

# Helm Operator Helm Repositroy
variable "helm_operator_helm_repository" {
  description = "The helm repository for helm-operator"
  type        = string
  default     = "https://charts.fluxcd.io"
}

# Helm Operator Helm Chart name
variable "helm_operator_helm_chart_name" {
  description = "The helm chart name for helm-operator"
  type        = string
  default     = "helm-operator"
}

# Helm Operator Helm Chart version
variable "helm_operator_helm_chart_version" {
  description = "The helm chart version for helm-operator"
  type        = string
  default     = "1.1.0"
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
