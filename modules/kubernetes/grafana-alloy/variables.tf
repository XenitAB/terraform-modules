variable "alloy-configmap-config" {
  description = "Content for the configmap in order to configure the alloy service."
  type        = string
  default     = ""
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
  })
  default = {
    azure_key_vault_name = ""
  }
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
  description = "Core key vault id"
  type        = string
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
