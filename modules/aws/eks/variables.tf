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
  validation {
    condition     = var.eks_name_suffix < 3
    error_message = "The eks_name_suffix can only be 1 or 2."
  }
}

variable "eks_authorized_ips" {
  description = "Authorized IPs to access EKS API"
  type        = list(string)
}

variable "eks_config" {
  description = "The EKS Config"
  type = object({
    version    = string
    cidr_block = string
    node_pools = list(object({
      name           = string
      version        = string
      instance_types = list(string)
      min_size       = number
      max_size       = number
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

variable "enabled_cluster_log_types" {
  description = "Which EKS controller logs should be saved"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "starboard_enabled" {
  description = "Should starboard be enaled"
  type        = bool
  default     = false
}
