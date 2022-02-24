variable "cloud_provider" {
  description = "Cloud provider used for starboard"
  type        = string
}

variable "starboard_role_arn" {
  description = "starboard role arn used to download ECR images, this only applies to AWS"
  type        = string
  default     = ""
}

variable "trivy_role_arn" {
  description = "trivy role arn used to download ECR images, this only applies to AWS"
  type        = string
  default     = ""
}
