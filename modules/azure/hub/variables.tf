variable "regions" {
  description = "The Azure Regions to configure"
  type = list(object({
    location       = string
    location_short = string
  }))
}

variable "environment" {
  description = "The environment (short name) to use for the deploy"
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
  type = map(object({
    address_space = list(string)
    subnets = list(object({
      name              = string
      cidr              = string
      service_endpoints = list(string)
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
