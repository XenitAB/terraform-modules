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
  default     = ""
}

variable "dns_zone_enabled" {
  description = "Should dns zone be enabled"
  type        = bool
  default     = false
}

variable "flow_log_enabled" {
  description = "Should flow logs be enabled"
  type        = bool
  default     = false
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

variable "vpc_peering_config_requester" {
  description = "VPC Peering configuration requester"
  type = list(object({
    name                   = string
    peer_owner_id          = string
    peer_vpc_id            = string
    destination_cidr_block = string
  }))
  default = []
}

variable "vpc_peering_config_accepter" {
  description = "VPC Peering configuration accepter"
  type = list(object({
    name                   = string
    peer_owner_id          = string
    destination_cidr_block = string
  }))
  default = []
}
