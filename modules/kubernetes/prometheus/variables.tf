variable "remote_write_enabled" {
  description = "If remote write should be enabled or not"
  type        = bool
  default     = true
}

variable "remote_write_url" {
  description = "The URL where to send prometheus remote_write data"
  type        = string
}

variable "volume_claim_enabled" {
  description = "If prometheus should store data localy"
  type        = bool
  default     = true
}

variable "volume_claim_storage_class_name" {
  description = "StorageClass name that your pvc will use"
  type        = string
  default     = "default"
}

variable "volume_claim_size" {
  description = "Size of prometheus disk"
  type        = string
  default     = "5Gi"
}

variable "cluster_name" {
  description = "Name of the prometheus cluster"
  type        = string
}

variable "environment" {
  description = "The environment in which the prometheus instance is deployed"
  type        = string
}

variable "tenant_id" {
  description = "The tenant id label to apply to all metrics in remote write"
  type        = string
  default     = ""
}

variable "resource_selector" {
  description = "Monitoring type labels to look for in Prometheus resources"
  type        = list(string)
  default     = ["platform"]
}

variable "namespace_selector" {
  description = "Kind labels to look for in namespaces"
  type        = list(string)
  default     = ["platform"]
}

variable "alertmanager_enabled" {
  description = "If alertmanager should be setup or not"
  type        = bool
  default     = false
}

variable "linkerd_enabled" {
  description = "Should linkerd be enabled"
  type        = bool
  default     = false
}
