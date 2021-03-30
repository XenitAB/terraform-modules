variable "remote_write_enabled" {
  description = "If remote write should be enabled or not"
  type        = bool
  default     = true
}

variable "remote_write_url" {
  description = "The URL where to send prometheus remote_write data"
  type        = string
}

variable "remote_write_name" {
  description = "The name of the remote write in prometheus"
  type        = string
  default     = "xenitInfra"
}

variable "remote_tls_secret_name" {
  description = "The secret name of tls for remote write"
  type        = string
  default     = "client-certificate" #tfsec:ignore:GEN001
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
