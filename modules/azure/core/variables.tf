variable "location_short" {
  description = "The location shortname for the subscription"
  type        = string
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
  type = object({
    address_space = list(string)
    dns_servers   = list(string)
    subnets = list(object({
      name              = string
      cidr              = string
      service_endpoints = list(string)
      aks_subnet        = bool
    }))
  })
}

variable "route_config" {
  description = "Route configuration. Not applied to aks subnets."
  type = list(object({
    subnet_name = string # Short name for the subnet
    routes = list(object({
      name                   = string # Name of the route
      address_prefix         = string # Example: 192.168.0.0/24
      next_hop_type          = string # VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None
      next_hop_in_ip_address = string # Only set if next_hop_type is VirtualAppliance
    }))

  }))
  default = []
}

variable "peering_config" {
  description = "Peering configuration"
  type = list(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_forwarded_traffic      = bool
    use_remote_gateways          = bool
    allow_virtual_network_access = bool
  }))
  default = []
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

variable "enable_storage_account" {
  description = "Should a storage account be created in the core resource group? (used for diagnostics)"
  type        = bool
  default     = false
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}
