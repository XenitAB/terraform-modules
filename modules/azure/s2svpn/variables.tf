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

variable "core_name" {
  description = "The commonName for the core infrastructure"
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

variable "local_gateway_address" {
  description = "Local gateway address"
  type        = string
}

variable "local_gateway_address_space" {
  description = "Local gateway address space"
  type        = list(string)
}

variable "unique_suffix" {
  description = "Unique suffix that is used in globally unique resources names"
  type        = string
  default     = ""
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "shared_secret" {
  description = "Shared secret for vpn connection"
  type        = string
  #sensitive   = true
  default     = ""
}

variable "vpn_type" {
  description = "vpn type"
  type        = string
  default     = "RouteBased"
}