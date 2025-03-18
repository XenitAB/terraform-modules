variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    storage_account_name      = string,
    storage_account_container = string
  })
  default = {
    storage_account_name      = ""
    storage_account_container = ""
  }
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
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

variable "subscription_id" {
  description = "The Azure subscription id"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type = string
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}