variable "aks_name" {
  description = "The name of the aks clusters"
  type        = string
}

variable "aks_name_suffix" {
  description = "The suffix for the aks clusters"
  type        = number
}

variable "azure_service_operator_config" {
  description = "Azure Service Operator configuration"
  type = object({
    cluster_config = optional(object({
      sync_period    = optional(string, "1m")
      enable_metrics = optional(bool, false)
      crd_pattern    = optional(string, "") # never set this to '*', limit this to the resources that are actually needed
    }), {})
    tenant_namespaces = optional(list(object({
      name = string
    })), [])
  })
  default = {}

  validation {
    condition     = var.azure_service_operator_config.cluster_config.crd_pattern != "*"
    error_message = "Installing all CRD:s in the cluster is not supported, please limit to the ones needed"
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

variable "subscription_id" {
  description = "The Azure subscription id"
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant id"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}