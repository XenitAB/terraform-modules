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
  default     = "aks1"
}

variable "environment" {
  description = "The environment in which the prometheus instance is deployed"
  type        = string
  default     = "dev"
}
