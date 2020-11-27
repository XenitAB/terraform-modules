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
  description = "The suffix for the aks clusters"
  type        = number
  default     = 1
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

variable "kubernetes_network_policy_default_deny" {
  description = "Should a network policy be created in each group namespace that disables traffic from other namespaces"
  type        = bool
  default     = true
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
    aks_managed_identity = object({
      id   = string
      name = string
    })
  })
}

variable "aad_pod_identity" {
  description = "Configuration for aad pod identity"
  type = map(object({
    id        = string
    client_id = string
  }))
}

variable "azure_devops_organization" {
  description = "Azure Devops organization root"
  type        = string
  default     = ""
}

variable "azure_devops_project" {
  description = "Azure Devops project root"
  type        = string
  default     = ""
}

variable "fluxcd_v2_enabled" {
  description = "Should fluxcd-v2 be enabled"
  type        = bool
  default     = true
}

variable "aad_pod_identity_enabled" {
  description = "Should aad-pod-identity be enabled"
  type        = bool
  default     = true
}

variable "opa_gatekeeper_enabled" {
  description = "Should OPA Gatekeeper be enabled"
  type        = bool
  default     = true
}

variable "cert_manager_enabled" {
  description = "Should Cert Manager be enabled"
  type        = bool
  default     = true
}

variable "ingress_nginx_enabled" {
  description = "Should Ingress NGINX be enabled"
  type        = bool
  default     = true
}

variable "external_dns_enabled" {
  description = "Should External DNS be enabled"
  type        = bool
  default     = true
}

variable "velero_enabled" {
  description = "Should Velero be enabled"
  type        = bool
  default     = false
}

variable "external_dns_identity" {
  description = "External DNS identity information"
  type = object({
    client_id   = string
    resource_id = string
  })
}

variable "velero" {
  description = "Velero configuration"
  type = object({
    azure_storage_account_name      = string
    azure_storage_account_container = string
    identity = object({
      client_id   = string
      resource_id = string
    })
  })
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}
