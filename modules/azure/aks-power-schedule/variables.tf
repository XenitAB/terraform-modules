variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
  default     = ""
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "shutdown_aks_cron_expression" {
  description = "The cron expression to use to shutdown AKS"
  type        = string
  default     = "0 20 * * * *"
}

variable "shutdown_aks_disabled" {
  description = "Should the ShutdownAKS function be disabled?"
  type        = bool
  default     = false
}
