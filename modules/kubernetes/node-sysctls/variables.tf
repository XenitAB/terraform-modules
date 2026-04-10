variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "node_sysctls_config" {
  description = "List of sysctl profiles to apply on cluster nodes. Each profile creates a DaemonSet that sets the specified sysctl parameters on nodes matching the node selector and tolerations."
  type = list(object({
    profile_name  = string
    sysctls       = map(string)
    node_selector = optional(map(string), {})
    tolerations = optional(list(object({
      key      = string
      operator = optional(string, "Equal")
      value    = optional(string, "")
      effect   = optional(string, "NoSchedule")
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for profile in var.node_sysctls_config : alltrue([
        for key, _ in profile.sysctls : can(regex("^(fs|kernel|net|vm)\\.", key))
      ])
    ])
    error_message = "All sysctl keys must start with 'fs.', 'kernel.', 'net.', or 'vm.'."
  }

  validation {
    condition     = length(var.node_sysctls_config) == length(distinct([for p in var.node_sysctls_config : p.profile_name]))
    error_message = "All node_sysctls_config profile names must be unique."
  }
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
