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

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "vm_max_map_count" {
  description = "The vm.max_map_count value to enforce on all eligible nodes"
  type        = number
  default     = 262144
}

variable "node_selector" {
  description = "Optional node selector used to scope the DaemonSet to specific nodes"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Optional tolerations for the DaemonSet"
  type = list(object({
    key               = optional(string)
    operator          = optional(string)
    value             = optional(string)
    effect            = optional(string)
    tolerationSeconds = optional(number)
  }))
  default = []
}
