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
  type        = string
  default     = "xks"
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}

variable "eks_cloudwatch_retention_period" {
  description = "eks cloudwatch retention period"
  type        = number
  default     = 30
}

variable "dns_zone" {
  description = "List of DNS Zone to create"
  type        = list(string)
}

variable "azad_kube_proxy_config" {
  description = "Azure AD Kubernetes Proxy configuration"
  type = object({
    cluster_name_prefix = string
    proxy_url_override  = string
  })
  default = {
    cluster_name_prefix = "eks"
    proxy_url_override  = ""
  }
}

variable "eks_admin_assume_principal_ids" {
  description = "ThePrincipal IDs that are allowed to assume EKS Admin role"
  type        = list(string)
}
