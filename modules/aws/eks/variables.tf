variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "Common name for the environment"
  type        = string
}

variable "region" {
  description = "The AWS region to configure"
  type = object({
    location       = string
    location_short = string
  })
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

variable "eks_configuration" {
  description = "The EKS Config"
  type = object({
    kubernetesVersion = string
    nodeGroups = list(object({
      name            = string
      release_version = string
      min_size        = number
      max_size        = number
      disk_size       = number
      instance_types  = list(string)
    }))
  })
}

variable "dns_zone" {
  description = "The DNS Zone that will be used by the EKS cluster"
  type        = string
}

variable "namespaces" {
  description = "List of namespaces to create in the cluster"
  type        = set(string)
}

variable "velero_s3_bucket_arn" {
  description = "ARN of velero s3 bucket"
  type = string
}
