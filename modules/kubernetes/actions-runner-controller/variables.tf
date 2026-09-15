variable "arc_config" {
  description = "Configuration for the GitHub Actions Runner Controller (ARC) controller deployment."
  type = object({
    chart_version             = optional(string, "0.14.2")
    namespace                 = optional(string, "arc-system")
    replica_count             = optional(number, 1)
    watch_single_namespace    = optional(string, "")
    resources_cpu_requests    = optional(string, "50m")
    resources_memory_requests = optional(string, "128Mi")
    resources_memory_limit    = optional(string, "512Mi")
  })
  default = {}
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "enabled" {
  description = "If the GitHub Actions Runner Controller should be deployed. Disabled by default; enable it explicitly for tenants that need self-hosted runners."
  type        = bool
  default     = false
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

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
