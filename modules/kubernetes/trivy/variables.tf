variable "acr_name_override" {
  description = "Override default name of ACR"
  type        = string
  default     = ""
}

variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}

variable "aks_name" {
  description = "The commonName to use for the deploy"
  type        = string
}

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

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
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

variable "starboard_exporter_enabled" {
  description = "If the starboard-exporter Helm chart should be deployed"
  type        = bool
  default     = true
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "volume_claim_storage_class_name" {
  description = "StorageClass name that your pvc will use"
  type        = string
  default     = "default"
}
