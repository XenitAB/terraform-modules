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
}
