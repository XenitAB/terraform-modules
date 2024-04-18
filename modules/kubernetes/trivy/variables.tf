variable "client_id" {
  description = "Azure specific, the client_id for aadpodidentity with access to ACR"
  type        = string
  default     = ""
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "resource_id" {
  description = "Azure specific, the resource_id for aadpodidentity to the resource"
  type        = string
  default     = ""
}

variable "volume_claim_storage_class_name" {
  description = "StorageClass name that your pvc will use"
  type        = string
  default     = "default"
}

variable "starboard_exporter_enabled" {
  description = "If the starboard-exporter Helm chart should be deployed"
  type        = bool
  default     = true
}
