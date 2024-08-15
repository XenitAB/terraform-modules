variable "azure_config" {
  description = "Azure specific configuration"
  type = object({
    azure_key_vault_name = string
  })
  default = {
    azure_key_vault_name = ""
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

variable "cluster_name" {
  description = "Name of the K8S cluster"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "excluded_namespaces" {
  description = "Namespaces to not ship logs from"
  type        = list(string)
  default     = []
}

variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "loki_address" {
  description = "The address of the Loki instance to send logs to"
  type        = string
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "region" {
  description = "The region in which the promtail instance is deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}