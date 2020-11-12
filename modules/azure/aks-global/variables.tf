variable "location_short" {
  description = "The Azure region short name."
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

variable "aks_name" {
  description = "The name for the aks clusters"
  type        = string
}

variable "core_name" {
  description = "The name for the core infrastructure"
  type        = string
}

variable "namespaces" {
  description = "The namespaces that should be created in Kubernetes."
  type = list(
    object({
      name                    = string
      delegate_resource_group = bool
      labels                  = map(string)
      flux = object({
        enabled      = bool
        azdo_org     = string
        azdo_project = string
        azdo_repo    = string
      })
    })
  )
}

variable "dns_zone" {
  description = "The DNS Zone to create"
  type        = string
}

variable "aks_authorized_ips" {
  description = "Authorized IPs to access AKS API"
  type        = list(string)
}
