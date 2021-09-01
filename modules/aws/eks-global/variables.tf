variable "environment" {
  description = "The environemnt"
  type        = string
}

variable "name" {
  description = "Name for the deployment"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to add to unique names such as S3 buckets and IAM roles"
  type = string
  default = "xkf"
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes"
  type = list(
    object({
      name = string
    })
  )
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "eks_group_name_prefix" {
  description = "Prefix for EKS Azure AD groups"
  type        = string
  default     = "eks"
}
