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

variable "core_name" {
  description = "The commonName for the core infrastructure"
  type        = string
}

variable "aks_name_suffix" {
  description = "The commonName for the aks clusters"
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
  type        = string
}

variable "aks_authorized_ips" {
  description = "Authorized IPs to access AKS API"
  type        = list(string)
}

variable "aks_public_ip_prefix" {
  description = "Public IP AKS egresses from"
  type        = string
}

variable "aad_groups" {
  description = "Configuration for aad groups"
  type = object({
    view = map(any)
    edit = map(any)
    cluster_admin = object({
      id   = string
      name = string
    })
    cluster_view = object({
      id   = string
      name = string
    })
  })
}

variable "aad_pod_identity" {
  description = "Configuration for aad pod identity"
  type        = map(any)
}

variable "azure_devops_organization" {
  description = "Azure Devops organization used to configure azdo-proxy"
  type        = string
}

variable "helm_operator_credentials" {
  description = "ACR credentials pased to Helm Operator"
  type = object({
    client_id = string
    secret    = string
  })
}
