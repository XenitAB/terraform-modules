variable "aad_groups" {
  description = "Configuration for Azure AD Groups (AAD Groups)"
  type = list(object({
    namespace = string
    id        = string
    name      = string
  }))
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "dns_provider" {
  description = "DNS provider to use."
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

variable "extra_args" {
  description = "Extra command line arguments that is not covered by the Helm chart values"
  type        = list(string)
}

variable "fleet_infra_config" {
  description = "Fleet infra configuration"
  type = object({
    git_repo_url        = string
    argocd_project_name = string
    k8s_api_server_url  = string
  })
}

variable "global_resource_group_name" {
  description = "The Azure global resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "location_short" {
  description = "The Azure region short name."
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

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "rbac_create" {
  description = "If role assignments should be created for the hosted zones"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "sources" {
  description = "k8s resource types to observe"
  type        = list(string)
}

variable "subscription_id" {
  description = "The Azure subscription id"
  type        = string
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "txt_owner_id" {
  description = "The txt-owner-id for external-dns"
  type        = string
}
