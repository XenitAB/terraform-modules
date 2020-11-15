# AAD-Pod-Identity Namespace name
variable "aad_pod_identity_namespace" {
  description = "The namespace for aad-pod-identity"
  type        = string
  default     = "aad-pod-identity"
}

# Helm Operator Helm release name
variable "aad_pod_identity_helm_release_name" {
  description = "The helm release name for aad-pod-identity"
  type        = string
  default     = "aad-pod-identity"
}

# Helm Operator Helm Repositroy
variable "aad_pod_identity_helm_repository" {
  description = "The helm repository for aad-pod-identity"
  type        = string
  default     = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
}

# Helm Operator Helm Chart name
variable "aad_pod_identity_helm_chart_name" {
  description = "The helm chart name for aad-pod-identity"
  type        = string
  default     = "aad-pod-identity"
}

# Helm Operator Helm Chart version
variable "aad_pod_identity_helm_chart_version" {
  description = "The helm chart version for aad-pod-identity"
  type        = string
  default     = "2.0.0"
}

# Namespace configuration
variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name = string
    })
  )
}
