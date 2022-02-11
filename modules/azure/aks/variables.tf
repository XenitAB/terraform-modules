variable "location_short" {
  description = "The Azure region short name"
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
  description = "The suffix for the Azure Kubernetes Service (AKS) clusters"
  type        = number
}

variable "aks_config" {
  description = "The Azure Kubernetes Service (AKS) configuration"
  type = object({
    kubernetes_version = string
    sku_tier           = string
    default_node_pool = object({
      orchestrator_version = string
      node_labels          = map(string)
      os_disk_type         = string
    })
    additional_node_pools = list(object({
      name                 = string
      orchestrator_version = string
      vm_size              = string
      min_count            = number
      max_count            = number
      node_taints          = list(string)
      node_labels          = map(string)
      os_disk_type         = string
      spot_enabled         = bool
      spot_max_price       = number
    }))
  })

  # Spot max price is set when spot is enabled
  validation {
    condition = alltrue([
      for np in var.aks_config.additional_node_pools : (!np.spot_enabled && np.spot_max_price == null) || (np.spot_enabled && np.spot_max_price != null)
    ])
    error_message = "The spot_max_price cannot be null when spot_enabled is true."
  }
}

variable "ssh_public_key" {
  description = "SSH public key to add to servers"
  type        = string
}

variable "aks_authorized_ips" {
  description = "Authorized IPs to access AKS API"
  type        = list(string)
}

variable "aks_public_ip_prefix_id" {
  description = "Public IP ID AKS egresses from"
  type        = string
}

variable "aad_groups" {
  description = "Configuration for Azure AD Groups (AAD Groups)"
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
    aks_managed_identity = object({
      id   = string
      name = string
    })
  })
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes"
  type = list(
    object({
      name                    = string
      delegate_resource_group = bool
    })
  )
}

variable "aks_managed_identity_group_id" {
  description = "The group id of aks managed identity"
  type        = string
}
