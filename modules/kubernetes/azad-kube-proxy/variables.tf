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

variable "allowed_ips" {
  description = "The external IPs allowed through the ingress to azad-kube-proxy"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "fqdn" {
  description = "The name to use with the ingress (fully qualified domain name). Example: k8s.example.com"
  type        = string
}

variable "azure_ad_group_prefix" {
  description = "The Azure AD group prefix to filter for"
  type        = string
  default     = ""
}

variable "cluster_id" {
  description = "Unique identifier of the cluster across regions and instances."
  type        = string
}

variable "private_ingress_enabled" {
  description = "If true will create a public and private ingress controller. Otherwise only a public ingress controller will be created."
  type        = bool
  default     = false
}

variable "use_private_ingress" {
  description = "If true, private ingress will be used by azad-kube-proxy"
  type        = bool
  default     = false
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
variable "key_vault_id" {
  description = "core keyvault id"
  type        = string
}

variable "dns_zones" {
  description = "List of DNS Zones"
  type        = list(string)
}

variable "oidc_issuer_url" {
  description = "Kubernetes OIDC issuer URL for workload identity."
  type        = string
}

variable "resource_group_name" {
  description = "The Azure resource group name"
  type        = string
}

variable "location" {
  description = "The Azure region name."
  type        = string
}

variable "key_vault_name" {
  description = "The keyvault name."
  type        = string
}
