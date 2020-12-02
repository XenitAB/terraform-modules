variable "regions" {
  description = "The Azure Regions to configure"
  type = list(object({
    location       = string
    location_short = string
  }))
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The subscriptionCommonName to use for the deploy"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "vnet_config" {
  description = "Address spaces used by virtual network."
  type = map(object({
    address_space = list(string)
    subnets = list(object({
      name              = string
      cidr              = string
      service_endpoints = list(string)
      aks_subnet        = bool
    }))
  }))
}

variable "peering_config" {
  description = "Peering configuration"
  type = map(list(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_forwarded_traffic      = bool
    use_remote_gateways          = bool
    allow_virtual_network_access = bool
  })))
  default = {}
}

variable "group_name_separator" {
  description = "Separator for group names"
  type        = string
  default     = "-"
}

variable "azure_ad_group_prefix" {
  description = "Prefix for Azure AD Groupss"
  type        = string
  default     = "az"
}
