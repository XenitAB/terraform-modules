variable "aks_automation_enabled" {
  description = "Should AKS automation be enabled"
  type        = bool
  default     = false
}

# Monthly occurence currently not supported
variable "aks_automation_config" {
  description = "AKS automation configuration"
  type = object({
    public_network_access_enabled = optional(bool, false),
    alerts_config = optional(object({
      enabled     = optional(bool, true),
      frequency   = optional(string, ""),
      window_size = optional(string, ""),
      severity    = optional(number, 3),
      email_to    = optional(string, ""),
    }), {}),
    runbook_schedules = optional(list(object({
      name        = string,
      frequency   = string,
      interval    = optional(number, null),
      start_time  = string, # ISO 8601 format
      timezone    = optional(string, "Europe/Stockholm")
      expiry_time = optional(string, ""),
      description = string,
      week_days   = optional(list(string), []),
      operation   = string,
      node_pools  = optional(list(string), []),
    })), [])
  })
  default = {}

  validation {
    condition = length([
      for schedule in var.aks_automation_config.runbook_schedules : true
      if contains(["OneTime", "Day", "Hour", "Week"], schedule.frequency)
    ]) == length(var.aks_automation_config.runbook_schedules)
    error_message = "The frequency of the schedule must be either 'OneTime', 'Day', 'Hour', 'Week'."
  }
}

variable "notification_email" {
  description = "Where to send email alerts"
  type        = string
  default     = "DG-Team-DevOps@xenit.se"
}

variable "aks_joblogs_retention_days" {
  description = "How many days to keep logs from automation jobs"
  type        = number
  default     = 7
}

variable "location" {
  description = "The Azure region"
  type        = string
  default     = "West Europe"
}

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

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "azure_ad_group_prefix" {
  description = "Prefix for Azure AD Groups"
  type        = string
  default     = "az"
}

variable "subscription_name" {
  description = "The commonName for the subscription"
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

variable "aks_default_node_pool_vm_size" {
  description = "The VM size of the AKS clusters default node pool. Do not override unless explicitly required."
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "aks_default_node_pool_zones" {
  description = "The default node pool zones."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "aks_config" {
  description = "The Azure Kubernetes Service (AKS) configuration"
  type = object({
    version                = string
    sku_tier               = optional(string, "Free")
    default_node_pool_size = optional(number, 1)
    # Will replace the default cluster auto scaler expander with a priority expander, 
    # see https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/expander/priority/readme.md#configuration
    priority_expander_config = optional(map(list(string)))
    node_pools = list(object({
      name              = string
      version           = string
      vm_size           = string
      kubelet_disk_type = optional(string, "OS")
      zones             = optional(list(string), ["1", "2", "3"])
      min_count         = number
      max_count         = number
      spot_enabled      = bool
      spot_max_price    = number
      node_taints       = list(string)
      node_labels       = map(string)
      upgrade_settings = optional(object({
        drain_timeout_in_minutes      = optional(number, 30)
        node_soak_duration_in_minutes = optional(number, 0)
        max_surge                     = optional(number, 33)
        }), {
        drain_timeout_in_minutes      = 30
        node_soak_duration_in_minutes = 0
        max_surge                     = 33
      })
    }))
    upgrade_settings = optional(object({
      drain_timeout_in_minutes      = optional(number, 30)
      node_soak_duration_in_minutes = optional(number, 0)
      max_surge                     = optional(number, 33)
      }), {
      drain_timeout_in_minutes      = 30
      node_soak_duration_in_minutes = 0
      max_surge                     = 33
    })
  })

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.aks_config.sku_tier)
    error_message = "Invalid pricing_tier: ${var.aks_config.sku_tier}. Allowed vallues: ['Free', 'Standard', 'Premium']"
  }

  validation {
    condition = alltrue([
      for np in var.aks_config.node_pools : split(".", np.version)[1] <= split(".", var.aks_config.version)[1]
    ])
    error_message = "The node Kubernetes version should not be newer than the cluster version, upgrade the cluster first."
  }

  validation {
    condition = alltrue([
      for np in var.aks_config.node_pools : length(np.name) <= 12
    ])
    error_message = "The name value cannot be longer than 12 characters."
  }

  validation {
    condition = alltrue([
      for np in var.aks_config.node_pools : can(regex("^[a-z0-9]+$", np.name))
    ])
    error_message = "The name value has to be lowercase alphanumeric."
  }

  validation {
    condition = alltrue([
      for np in var.aks_config.node_pools : can(regex("^[a-z]", np.name))
    ])
    error_message = "The name value has to begin with a lowercase letter."
  }

  validation {
    condition = alltrue([
      for np in var.aks_config.node_pools : can(regex("[12]$", np.name))
    ])
    error_message = "The name value should end with a 1 or 2 to enable blue green pool creation."
  }

  # Spot max price is set when spot is enabled
  validation {
    condition = alltrue([
      for np in var.aks_config.node_pools : (!np.spot_enabled && np.spot_max_price == null) || (np.spot_enabled && np.spot_max_price != null)
    ])
    error_message = "The spot_max_price cannot be null when spot_enabled is true."
  }
}

variable "aks_cost_analysis_enabled" {
  description = "If AKS cost analysis should be enabled"
  type        = bool
  default     = false
}

variable "alerts_enabled" {
  description = "If metric alerts on audit logs are enabled"
  type        = bool
  default     = false
}

variable "azure_policy_enabled" {
  description = "If the Azure Policy for Kubernetes add-on should be enabled"
  type        = bool
  default     = false
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
      name = string
    })
  )
}

variable "aks_audit_log_retention" {
  description = "The aks audit log retention in days, 0 = infinite"
  type        = number
  default     = 30
}

variable "log_eventhub_name" {
  description = "The eventhub name for k8s logs"
  type        = string
}

variable "log_eventhub_authorization_rule_id" {
  description = "The authoritzation rule id for event hub"
  type        = string
}

variable "defender_enabled" {
  description = "If Defender for Containers should be enabled"
  type        = bool
  default     = false
}

variable "audit_config" {
  description = "Kubernetes audit log configuration"
  type = object({
    destination_type = optional(string, "StorageAccount")
    analytics_workspace = optional(object({
      sku_name       = optional(string, "PerGB2018")
      daily_quota_gb = optional(number, -1)
      reservation_gb = optional(number, 0)
      retention_days = optional(number, 30)
    }), {})
  })
  default = {}

  validation {
    condition     = contains(["AnalyticsWorkspace", "StorageAccount"], var.audit_config.destination_type)
    error_message = "Invalid destination_type: ${var.audit_config.destination_type}. Allowed vallues: ['AnalyticsWorkspace', 'StorageAccount']"
  }
}

variable "defender_config" {
  description = "The Microsoft Defender for containers configuration"
  type = object({
    analytics_workspace = optional(object({
      sku_name       = optional(string, "PerGB2018")
      daily_quota_gb = optional(number, -1)
      reservation_gb = optional(number, 0)
      retention_days = optional(number, 30)
    }), {})
    kubernetes_discovery_enabled      = optional(bool, false)
    kubernetes_sensor_enabled         = optional(bool, true)
    vulnerability_assessments_enabled = optional(bool, true)
  })
  default = {}
}

variable "cilium_enabled" {
  description = "If enabled, will use Azure CNI with Cilium instead of kubenet"
  type        = bool
  default     = false
}

variable "add_default_security_lb_rule" {
  type        = bool
  description = "Should default LB rule (allow internat to azure lb ips) be applied to NSG?"
  default     = false
}

variable "additonal_security_rules" {
  description = "Rules for trafic in the NSG associated to AKS"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}
