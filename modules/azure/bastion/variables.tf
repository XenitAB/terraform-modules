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

variable "bastion_subnet_config" {
  description = "configuration for all Bastion host subnets"
  type = map(object({
    name = string
    cidr = string
  }))
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}
