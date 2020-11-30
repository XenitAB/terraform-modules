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
      flux = object({
        enabled = bool
        repo    = string
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

variable "public_ip_prefix_configuration" {
  description = "Configuration for public ip prefix"
  type = object({
    count         = number
    prefix_length = number
  })
  default = {
    count         = 2
    prefix_length = 30
  }
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}
