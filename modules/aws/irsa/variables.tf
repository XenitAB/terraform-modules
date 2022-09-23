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

variable "policy_json" {
  description = "Permissions to apply to the created role"
  type        = string
  default     = ""
}

# The below variable is introduced to make it possible to optionally create an AWS IAM policy
# in combination with being able to populate the policy_json from a data source
variable "policy_json_create" {
  description = "Create AWS IAM policy from the policy document in policy_json"
  type        = bool
  default     = true
}

variable "policy_permissions_arn" {
  description = "Permissions to apply to the created role"
  type        = set(string)
  default     = []
}
