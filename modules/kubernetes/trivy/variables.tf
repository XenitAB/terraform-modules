variable "client_id" {
  description = "Azure specific, the client_id for aadpodidentity with access to ACR"
  type        = string
  default     = ""
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
