variable "aad_groups" {
  description = "Configuration for Azure AD Groups (AAD Groups)"
  type = list(object({
    namespace = string
    id        = string
    name      = string
  }))
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

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
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

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}
