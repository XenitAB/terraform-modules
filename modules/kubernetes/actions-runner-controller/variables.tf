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

variable "aks_name" {
  description = "The AKS cluster short name, e.g. 'aks'. Required if arc_runner_set_config is set."
  type        = string
  default     = ""
}

variable "arc_runner_set_config" {
  description = "Configuration for the runner scale set and its GitHub App credentials. Leave null to deploy only the controller."
  type = object({
    runner_scale_set_name       = string
    github_config_url           = string
    github_app_id               = string
    github_app_installation_id  = string
    key_vault_name              = string
    key_vault_secret_name       = optional(string, "github-arc-private-key")
    runner_group                = optional(string, "")
    min_runners                 = optional(number, 0)
    max_runners                 = optional(number, 8)
    credentials_migration_phase = optional(string, "managed")
  })
  default = null

  validation {
    condition     = var.arc_runner_set_config == null ? true : contains(["protect", "handoff", "managed"], var.arc_runner_set_config.credentials_migration_phase)
    error_message = "credentials_migration_phase must be protect, handoff, or managed."
  }
}

variable "azure_tenant_id" {
  description = "Azure AD tenant ID for the ExternalSecret's SecretStore. Required if arc_runner_set_config is set."
  type        = string
  default     = ""
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault holding the GitHub App private key. Required if arc_runner_set_config is set."
  type        = string
  default     = ""
}

variable "location_short" {
  description = "The short name of the Azure region, e.g. 'sdc'. Required if arc_runner_set_config is set."
  type        = string
  default     = ""
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
