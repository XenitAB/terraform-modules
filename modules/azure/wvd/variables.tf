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

variable "wvd_name_suffix" {
  description = "The suffix for the wvd host pool"
  type        = number
  default     = 1
}

variable "wvd_config" {
  description = "The Windows Virtual Dekstop (WVD) configuration"
  type = object({
    pool_type = string
    load_balancer_type = string
    maximum_allowed_sessions = number
    application_group_type = string
    default_node_pool = object({
      orchestrator_version = string
      vm_size              = string
      min_count            = number
      max_count            = number
      node_labels          = map(string)
    })
  })
}
