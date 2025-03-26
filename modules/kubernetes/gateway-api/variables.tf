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

variable "gateway_api_config" {
  description = "The Gateway API configuration"
  type = object({
    api_version       = optional(string, "v1.2.0")
    api_channel       = optional(string, "standard")
    gateway_name      = optional(string, "")
    gateway_namespace = optional(string, "")
  })
  default = {}

  validation {
    condition     = contains(["standard", "experimental"], var.gateway_api_config.api_channel)
    error_message = "Invalid API channel: ${var.gateway_api_config.api_channel}. Allowed vallues: ['standard', 'experimental']"
  }
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}