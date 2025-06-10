variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "external_secrets_config" {
  description = "External secrets operator config"
  type = object({
    log_level               = optional(string, "info")
    metrics_enabled         = optional(bool, false)
    pdb_enabled             = optional(bool, true)
    replica_count           = optional(number, 2)
    service_monitor_enabled = optional(bool, true)
  })
  default = {}
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