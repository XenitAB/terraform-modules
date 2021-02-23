variable "location_short" {
  description = "The Azure region short name."
  type        = string
}

variable "environment" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
  default     = ""
}

variable "storage_account_name" {
  description = "The storage account name"
  type        = string
  default     = ""
}

variable "storage_account_configuration" {
  description = "The storage account configuration"
  type = object({
    account_tier             = string
    account_replication_type = string
    account_kind             = string
  })
  default = {
    account_tier             = "Standard"
    account_replication_type = "GRS"
    account_kind             = "StorageV2"
  }
}

variable "storage_container_name" {
  description = "The storage container name"
  type        = string
  default     = "loki"
}

variable "kubernetes_namespace_name" {
  description = "The Kubernetes namespace name"
  type        = string
  default     = "loki"
}

variable "minio_helm_repository" {
  description = "The helm repository for minio"
  type        = string
  default     = "https://helm.min.io/"
}

variable "minio_helm_chart_name" {
  description = "The helm chart name for minio"
  type        = string
  default     = "minio"
}

variable "minio_helm_release_name" {
  description = "The helm release name for minio"
  type        = string
  default     = "loki-minio"
}

variable "loki_helm_repository" {
  description = "The helm repository for loki"
  type        = string
  default     = "https://grafana.github.io/loki/charts"
}

variable "loki_helm_chart_name" {
  description = "The helm chart name for loki"
  type        = string
  default     = "loki-stack"
}

variable "loki_helm_release_name" {
  description = "The helm release name for loki"
  type        = string
  default     = "loki"
}
