variable "acme_server" {
  description = "ACME server to add to the created ClusterIssuer"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "dns_zones" {
  description = "Map of DNS zones with id"
  type        = map(string)
}

variable "gateway_api_enabled" {
  description = "If Gateway API should be enabled"
  type        = bool
}

variable "global_resource_group_name" {
  description = "The Azure global resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "notification_email" {
  description = "Email address to send certificate expiration notifications"
  type        = string
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription id"
  type        = string
}
