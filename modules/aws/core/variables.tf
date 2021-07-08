variable "environment" {
  description = "The environment name to use for the deploy"
  type        = string
}

variable "name" {
  description = "Common name for the deploy"
  type        = string
}

variable "dns_zone" {
  description = "The DNS Zone host name"
  type        = string
}

variable "vpc_config" {
  description = "The configuration of the VPC"
  type = object({
    cidr_block = string
    public_subnets = list(object({
      cidr_block = string
      tags       = map(string)
    }))
    private_subnets = list(object({
      name_prefix             = string
      cidr_block              = string
      availability_zone_index = number
      public_routing_enabled  = bool
      tags                    = map(string)
    }))
  })
}

variable "vpc_peering_enabled" {
  description = "If true vpc peering will be configured"
  type        = bool
  default     = true
}

variable "vpc_peering_config" {
  description = "VPC Peering configuration"
  type = object({
    peer_owner_id          = string
    peer_vpc_id            = string
    destination_cidr_block = string
  })
  default = {
    destination_cidr_block = ""
    peer_owner_id          = ""
    peer_vpc_id            = ""
  }
}
