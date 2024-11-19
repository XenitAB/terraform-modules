variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The subscription commonName to use for the deploy"
  type        = string
}

variable "name" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "vnet_config" {
  description = "Address spaces used by virtual network"
  type = object({
    address_space = list(string)
    dns_servers   = list(string)
    subnets = list(object({
      name              = string
      cidr              = string
      service_endpoints = list(string)
      create_nsg        = bool
      security_rules = optional(list(object({
        name                       = optional(string)
        priority                   = optional(number)
        direction                  = optional(string)
        access                     = optional(string)
        protocol                   = optional(string)
        source_port_range          = optional(string)
        destination_port_range     = optional(string)
        source_address_prefix      = optional(string)
        destination_address_prefix = optional(string)
      })), [])
    }))
  })
}

variable "route_config" {
  description = "Route configuration. Not applied to AKS subnets"
  type = list(object({
    subnet_name                   = string                # Short name for the subnet
    disable_bgp_route_propagation = optional(bool, false) # Controls propagation of routes learned by BGP on that route table
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
  description = "Network peering configuration"
  type = list(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_forwarded_traffic      = bool
    use_remote_gateways          = bool
    allow_virtual_network_access = bool
    allow_gateway_transit        = optional(bool, false) # Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.
  }))
  default = []
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

variable "azure_role_definition_prefix" {
  description = "Prefix for Azure Role Definition names"
  type        = string
  default     = "role"
}

variable "enable_storage_account" {
  description = "Should a storage account be created in the core resource group? (used for diagnostics)"
  type        = bool
  default     = false
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
}

variable "notification_email" {
  description = "Email address to send alert notifications"
  type        = string
}

variable "alerts_enabled" {
  description = "Should alert rules be created by default"
  type        = bool
  default     = false
}

variable "log_common_name" {
  description = "The common name for the logs"
  type        = string
  default     = "log"
}

variable "resource_name_overrides" {
  description = "A way to override the resource names"
  type        = any
  default     = null
}
