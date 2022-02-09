variable "cloud_provider" {
  description = "Cloud provider used for starboard"
  type        = string
}

variable "role_arn" {
  description = "role arn used to download ECR images, this only applies to AWS"
  type        = string
  default     = ""
}
