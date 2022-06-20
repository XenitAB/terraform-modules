variable "environment" {
  description = "The environemnt"
  type        = string
}

variable "location" {
  description = "The Azure region name"
  type        = string
}

variable "location_short" {
  description = "The Azure region short name"
  type        = string
}

variable "lock_resource_group" {
  description = "Lock the resource group for deletion"
  type        = bool
  default     = false
}

variable "dns_zone" {
  description = "List of DNS Zone to create"
  type        = list(string)
}
