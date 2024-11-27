variable "aad_groups" {
  description = "Configuration for Azure AD Groups (AAD Groups)"
  type = object({
    view = map(any)
    edit = map(any)
    cluster_admin = object({
      id   = string
      name = string
    })
    cluster_view = object({
      id   = string
      name = string
    })
    aks_managed_identity = object({
      id   = string
      name = string
    })
  })
}

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

variable "gateway_api_config" {
  description = "The Gateway API configuration"
  type = object({
    gateway_name      = optional(string, "")
    gateway_namespace = optional(string, "")
  })
  default = {}
}

variable "global_resource_group_name" {
  description = "The Azure global resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name   = string
      labels = map(string)
      flux = optional(object({
        provider            = string
        project             = optional(string)
        repository          = string
        include_tenant_name = optional(bool, false)
        create_crds         = optional(bool, false)
      }))
    })
  )
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
