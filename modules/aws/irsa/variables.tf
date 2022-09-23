variable "name" {
  description = "Name of created IAM role and policy"
  type        = string
}

variable "oidc_providers" {
  description = "OIDC provider configuration"
  type = list(object({
    url = string
    arn = string
  }))
}

variable "kubernetes_namespace" {
  description = "Name of Kubernetes Namespace to trust"
  type        = string
}

variable "kubernetes_service_account" {
  description = "Name of Kubernetes Service Account to trust"
  type        = string
}

# The below variable is introduced to make it possible to optionally create an AWS IAM policy
# in combination with being able to populate the policy_json from a data source
# tflint-ignore: aws_iam_policy_sid_invalid_characters
variable "policy_json_create" {
  description = "Create AWS IAM policy from the policy document"
  type        = bool
}

variable "policy_json" {
  description = "Permissions to apply to the created role"
  type        = string
  default     = ""
}

variable "policy_permissions_arn" {
  description = "Permissions to apply to the created role"
  type        = set(string)
  default     = []
}

