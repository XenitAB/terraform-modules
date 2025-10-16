variable "azure_service_operator_enabled" {
  description = "If Azure Service Operator should be enabled"
  type        = bool
  default     = false
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "exclude_namespaces" {
  description = "Namespaces to exclude from admission and mutation."
  type        = list(string)
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "mirrord_enabled" {
  description = "If Gatekeeper validations should make an exemption for mirrord agent."
  type        = bool
  default     = false
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

