variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "Common name for the environment"
  type        = string
}

variable "core_name" {
  description = "The core name for the environment"
  type        = string
}

variable "eks_name_suffix" {
  description = "The suffix for the eks clusters"
  type        = number
  default     = 1
}

variable "eks_config" {
  description = "The EKS Config"
  type = object({
    kubernetes_version = string
    cidr_block         = string
    node_groups = list(object({
      name            = string
      release_version = string
      min_size        = number
      max_size        = number
      disk_size       = number
      instance_types  = list(string)
    }))
  })
}

variable "velero_config" {
  description = "Velero configuration"
  type = object({
    s3_bucket_arn = string
    s3_bucket_id  = string
  })
}
