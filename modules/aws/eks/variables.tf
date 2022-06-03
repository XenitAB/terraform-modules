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
      node_labels    = map(string)
    }))
  })

  validation {
    condition     = can(regex("^([0-9]\\d*)\\.([0-9]\\d*)$", var.eks_config.version))
    error_message = "Control plane version must only include major and minor version."
  }

  validation {
    condition = alltrue([
      for np in concat(var.eks_config.node_pools, [{ version : var.eks_config.version }]) : can(regex("^1.(21|22)", np.version))
    ])
    error_message = "The Kubernetes version has not been validated yet, supported versions are 1.21, 1.22."
  }

  validation {
    condition = alltrue([
      for np in var.eks_config.node_pools : split(".", np.version)[1] <= split(".", var.eks_config.version)[1]
    ])
    error_message = "The node Kubernetes version should not be newer than the cluster version, upgrade the cluster first."
  }
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
