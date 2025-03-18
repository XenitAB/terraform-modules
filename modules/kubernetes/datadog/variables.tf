variable "apm_ignore_resources" {
  description = "The resources that shall be excluded from APM"
  type        = list(string)
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

variable "datadog_site" {
  description = "Site to connect Datadog agent"
  type        = string
  default     = "datadoghq.eu"
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

variable "namespace_include" {
  description = "The namespace that should be checked by Datadog, example: kube_namespace:NAMESPACE kube_namespace:NAMESPACE2"
  type        = list(string)
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