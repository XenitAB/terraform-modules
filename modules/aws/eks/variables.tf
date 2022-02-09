variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "Common name for the environment"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to add to unique names such as S3 buckets and IAM roles"
  type        = string
  default     = "xks"
}

variable "eks_name_suffix" {
  description = "The suffix for the eks clusters"
  type        = number
  default     = 1
}

variable "eks_authorized_ips" {
  description = "Authorized IPs to access EKS API"
  type        = list(string)
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
      instance_types  = list(string)
    }))
  })
}

variable "cluster_role_arn" {
  description = "IAM role to attach to EKS cluster"
  type        = string
}

variable "node_group_role_arn" {
  description = "IAM role to attach to EKS node groups"
  type        = string
}

variable "aws_kms_key_arn" {
  description = "eks secrets customer master key"
  type        = string
}

variable "velero_config" {
  description = "Configuration for Velero"
  type = object({
    s3_bucket_id  = string
    s3_bucket_arn = string
  })
}

variable "starboard_enabled" {
  description = "Should starboard be enaled"
  type        = bool
  default     = false
}
