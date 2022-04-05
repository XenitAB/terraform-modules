variable "environment" {
  description = "The environment name to use for the deployment"
  type        = string
}

variable "name" {
  description = "Deployment name"
  type        = string
}

variable "dns_zone" {
  description = "The list of DNS Zone host names"
  type        = list(string)
}

variable "cidr_block" {
  description = "CIDR block of the VPC. The prefix length of the CIDR block must be 18 or less"
  type        = string
}

variable "flow_log_enabled" {
  description = "Should flow logs be enabled"
  type        = bool
  default     = false
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
