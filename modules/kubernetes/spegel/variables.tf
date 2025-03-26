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

variable "private_registry" {
  description = "Private registry to add to Spegels mirror list."
  type        = string
  default     = ""
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
