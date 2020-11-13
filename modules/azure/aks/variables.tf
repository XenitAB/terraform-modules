variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "aks_name" {
  description = "The commonName for the aks clusters"
  type        = string
}

variable "core_name" {
  description = "The commonName for the core infrastructure"
  type        = string
}

variable "aks_config" {
  description = "The Azure Kubernetes Service (AKS) configuration"
  type = object({
    kubernetes_version = string
    sku_tier           = string
    default_node_pool = object({
      orchestrator_version = string
      vm_size              = string
      min_count            = number
      max_count            = number
      node_labels          = map(string)
    })
    additional_node_pools = list(object({
      name                 = string
      orchestrator_version = string
      vm_size              = string
      min_count            = number
      max_count            = number
      node_taints          = list(string)
      node_labels          = map(string)
    }))
  })
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name                    = string
      delegate_resource_group = bool
      labels                  = map(string)
      flux = object({
        enabled      = bool
        azdo_org     = string
        azdo_project = string
        azdo_repo    = string
      })
    })
  )
}

variable "acr_name" {
  description = "Name of ACR registry to use for cluster"
  type = string
}

variable "helm_operator_credentials" {
  type = object({
    client_id = string
    secret = string
  })
}

variable "aks_authorized_ips" {
  type = list(string)
}

variable "aks_pip_prefix_id" {
  type = string
}

variable "aad_apps" {
  type = object({
    client_app_client_id     = string
    client_app_principal_id  = string
    client_app_client_secret = string
    server_app_client_id     = string
    server_app_client_secret = string
  })
}

variable "aad_groups" {
  type = string
}

variable "aad_pod_identity" {
  type = string
}

variable "azure_devops_organization" {
  description = "Azure Devops organization used to configure azdo-proxy"
}
