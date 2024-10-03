variable "grafana_alloy_config" {
  description = "The configmap which will be created for grafana-alloy"
  type        = string
}

variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
    keyvault_secret_name = string
  })
  default = {
    azure_key_vault_name = ""
    keyvault_secret_name = ""
  }
}

variable "aks_name" {
  description = "The AKS cluster short name, e.g. 'aks'."
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
