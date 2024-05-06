variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "podmonitor_loadbalancer" {
  description = "Enable podmonitor for loadbalancers?"
  type        = bool
  default     = true
}

variable "podmonitor_kubernetes" {
  description = "Enable podmonitor for kubernetes?"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "subscription_id" {
  description = "The subscription id where your kubernetes cluster is deployed"
  type        = string
}