variable "location_short" {
  description = "The location shortname for the subscription"
  type        = string
}

variable "environment" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "subscription_name" {
  description = "The subscription CommonName to use for the deploy"
  type        = string
}

variable "name" {
  description = "The name to use for the deploy"
  type        = string
}

variable "nat_gateway_public_ip_prefix_length" {
  description = "The Public IP Prefix length for NAT Gateway"
  type        = number
  default     = 31
}

variable "vnet_config" {
  description = "Address spaces used by virtual network."
  type = object({
    address_space = list(string)
    subnets = list(object({
      name              = string
      cidr              = string
      service_endpoints = list(string)
    }))
  })
}

variable "peering_config" {
  description = "Peering configuration"
  type = list(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_forwarded_traffic      = bool
    use_remote_gateways          = bool
    allow_virtual_network_access = bool
    allow_gateway_transit        = optional(bool, false)
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
