variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The commonName for the subscription"
  type        = string
}

variable "core_name" {
  description = "The name for the core infrastructure"
  type        = string
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes"
  type = list(
    object({
      name                    = string
      delegate_resource_group = bool
    })
  )
}

variable "dns_zone" {
  description = "List of DNS Zone to create"
  type        = list(string)
}

variable "aks_authorized_ips" {
  description = "Authorized IPs to access AKS API"
  type        = list(string)
}

variable "public_ip_prefix_configuration" {
  description = "Configuration for public IP prefix"
  type = object({
    count         = number
    prefix_length = number
  })
  default = {
    count         = 2
    prefix_length = 30
  }
}

variable "public_ip_prefix_name_override" {
  description = "Override the default public ip prefix name - the last digit"
  type        = string
  default     = ""
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "azure_ad_group_prefix" {
  description = "Prefix for Azure AD Groups"
  type        = string
  default     = "az"
}

variable "azad_kube_proxy_config" {
  description = "Azure AD Kubernetes Proxy configuration"
  type = object({
    cluster_name_prefix = string
    proxy_url_override  = string
  })
  default = {
    cluster_name_prefix = "aks"
    proxy_url_override  = ""
  }
}

variable "aks_managed_identity" {
  description = "AKS Azure AD managed identity"
  type        = string
}

variable "global_location_short" {
  description = "The Azure region short name where the global resources resides."
  type        = string
}

variable "acr_name_override" {
  description = "Override default name of ACR"
  type        = string
  default     = ""
}
