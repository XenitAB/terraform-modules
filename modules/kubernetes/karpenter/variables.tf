variable "aks_config" {
  description = "AKScluster configuration"
  type = object({
    cluster_id             = string
    cluster_name           = string
    cluster_endpoint       = string
    bootstrap_token        = string
    default_node_pool_size = number
    node_identities        = string
    node_resource_group    = string
    oidc_issuer_url        = string
    ssh_public_key         = string
    vnet_subnet_id         = string
  })

  sensitive = true
}

variable "karpenter_config" {
  description = "Karpenter configuration for the AKS cluster"
  type = object({
    node_ttl      = optional(string, "168h")
    replica_count = optional(number, 2)
    node_classes = optional(list(object({
      name         = optional(string, "default")
      image_family = optional(string, "Ubuntu2204")
      kubelet = optional(object({
        container_log_max_size  = optional(string, "10Mi")
        cpu_cfs_quota           = optional(bool, true)
        cpu_cfs_quota_period    = optional(string, "100ms")
        cpu_manager_policy      = optional(string, "none")
        topology_manager_policy = optional(string, "none")
      }), {})
    })), [{}])
    node_pools = optional(list(object({
      name              = string
      consolidate_after = optional(string, "5s")
      description       = string
      disruption_budgets = optional(list(object({
        duration = optional(string, null)
        nodes    = optional(string, "10%")
        reasons  = optional(list(string), ["Drifted", "Empty", "Underutilized"])
        schedule = optional(string, null)
      })), [])
      limits = object({
        cpu    = string
        memory = string
      })
      node_annotations = optional(map(string), {})
      node_class_ref   = optional(string, "default")
      node_labels      = optional(map(string), {})
      node_requirements = optional(list(object({
        key      = string
        operator = string
        values   = list(string)
      })), [])
      node_taints = optional(list(object({
        key    = string
        effect = string
        value  = string
      })), [])
      node_ttl = optional(string, "168h")
      weight   = optional(number, 1)
    })), [])
    settings = optional(object({
      batch_idle_duration = optional(string, "1s")
      batch_max_duration  = optional(string, "10s")
    }), {})
  })
  default = {
    bootstrap_token  = ""
    cluster_endpoint = ""
    node_identities  = ""
    ssh_public_key   = ""
    vnet_subnet_id   = ""
  }

  validation {
    condition = alltrue([
      for nc in var.karpenter_config.node_classes : contains(["Ubuntu2204", "AzureLinux"], nc.image_family)
    ])
    error_message = "The AKSNodeClass imageFamily must be either 'Ubuntu2204' or 'AzureLinux'."
  }
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure AKS resource group name"
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription id"
  type        = string
}