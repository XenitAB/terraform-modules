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


